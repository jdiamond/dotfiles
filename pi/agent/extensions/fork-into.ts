import { execFile } from "node:child_process";
import { mkdir } from "node:fs/promises";
import { homedir } from "node:os";
import { basename, isAbsolute, join, resolve } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function run(command: string, args: string[]): Promise<string> {
  return new Promise((resolveOutput, reject) => {
    execFile(command, args, { encoding: "utf8" }, (error, stdout, stderr) => {
      if (error) {
        reject(new Error(stderr.trim() || error.message));
        return;
      }
      resolveOutput(stdout);
    });
  });
}

function targetPath(args: string, cwd: string): string | undefined {
  let input = args.trim();
  if (!input) return undefined;

  if (
    input.length >= 2 &&
    ((input.startsWith('"') && input.endsWith('"')) ||
      (input.startsWith("'") && input.endsWith("'")))
  ) {
    input = input.slice(1, -1);
  }

  if (input === "~") return homedir();
  if (input.startsWith("~/")) input = join(homedir(), input.slice(2));
  return isAbsolute(input) ? input : resolve(cwd, input);
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("fork-into", {
    description: "Create a Herdr workspace and fork this session into it",
    handler: async (args, ctx) => {
      if (ctx.mode !== "tui") {
        ctx.ui.notify("/fork-into requires Pi's interactive terminal mode", "error");
        return;
      }

      const destination = targetPath(args, ctx.cwd);
      if (!destination) {
        ctx.ui.notify("Usage: /fork-into <path>", "error");
        return;
      }

      const sessionFile = ctx.sessionManager.getSessionFile();
      if (!sessionFile) {
        ctx.ui.notify("This session is ephemeral and cannot be forked", "error");
        return;
      }

      const herdr = process.env.HERDR_BIN_PATH || "herdr";
      let workspaceCreated = false;

      try {
        await mkdir(destination, { recursive: true });

        const output = await run(herdr, [
          "workspace",
          "create",
          "--cwd",
          destination,
          "--label",
          basename(destination) || destination,
          "--focus",
        ]);
        workspaceCreated = true;

        const response = JSON.parse(output);
        const paneId = response?.result?.root_pane?.pane_id;
        if (typeof paneId !== "string") {
          throw new Error("Herdr created the workspace but did not return its root pane ID");
        }

        const agentName = `pi-fork-${Date.now().toString(36)}`;
        await run(herdr, [
          "agent",
          "start",
          agentName,
          "--kind",
          "pi",
          "--pane",
          paneId,
          "--",
          "--fork",
          sessionFile,
        ]);

        ctx.ui.notify(`Forked session into Herdr workspace: ${destination}`, "info");
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        ctx.ui.notify(
          workspaceCreated
            ? `Workspace created at ${destination}, but Pi could not be started: ${message}`
            : `Could not create Herdr workspace: ${message}`,
          "error",
        );
      }
    },
  });
}
