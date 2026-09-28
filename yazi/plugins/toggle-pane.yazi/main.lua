--- @since 25.5.31
--- @sync entry

local function entry(st, job)
	local R = rt.mgr.ratio
	job = type(job) == "string" and { args = { job } } or job

	local panes = { parent = 1, current = 2, preview = 3 }
	st.parent = st.parent or R[1]
	st.current = st.current or R[2]
	st.preview = st.preview or R[3]

	local act, to = string.match(job.args[1] or "", "(.-)-(.+)")
	local index = panes[to]
	if act == "min" and index then
		st[to] = st[to] == R[index] and 0 or R[index]
	elseif act == "max" and index then
		local max = st[to] == 65535 and R[index] or 65535
		for name, pane_index in pairs(panes) do
			if name ~= to then
				st[name] = st[name] == 65535 and R[pane_index] or st[name]
			end
		end
		st[to] = max
	end

	if not st.old then
		st.old = Tab.layout
		Tab.layout = function(self)
			local all = st.parent + st.current + st.preview
			self._chunks = ui.Layout()
				:direction(ui.Layout.HORIZONTAL)
				:constraints({
					ui.Constraint.Ratio(st.parent, all),
					ui.Constraint.Ratio(st.current, all),
					ui.Constraint.Ratio(st.preview, all),
				})
				:split(self._area)
		end
	end

	if not act then
		Tab.layout, st.old = st.old, nil
		st.parent, st.current, st.preview = nil, nil, nil
	end
	ya.emit("app:resize", {})
end

return { entry = entry }
