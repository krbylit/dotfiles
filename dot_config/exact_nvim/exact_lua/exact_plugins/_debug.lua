-- Debug scripts loader
-- This file auto-loads debug utilities from utils/debug/
--
-- Available utilities (see utils/debug/README.md for full documentation):
--   - profile-quit: Automatic exit performance profiling
--   - indentation-change: Track indentation setting changes
--   - lag-detector: Real-time lag spike detection
--   - profile-runtime: Comprehensive runtime profiling
--   - window-switch-profiler: Window switching performance analysis
--   - memory-leak-detector: Resource accumulation monitoring
--
-- Uncomment the ones you want to enable by default:

-- require("utils.debug.profile-quit")
-- require("utils.debug.indentation-change")
-- require("utils.debug.lag-detector")
-- require("utils.debug.profile-runtime")
-- require("utils.debug.window-switch-profiler")
-- require("utils.debug.memory-leak-detector")

return {}
