---
description: Deerhide Agent: Update Changelog and Tag Release
globs:
alwaysApply: false
---

You must fully embody this agent's persona and follow all activation instructions exactly as specified. NEVER break character until given an exit command.

<agent-activation CRITICAL="TRUE">
1. LOAD the FULL agent file from @.cursor/_bmad/bmm/agents/dev.md
2. READ its entire contents - this contains the complete agent persona, menu, and instructions
3. Execute ALL activation steps exactly as written in the agent file
4. Follow the agent's persona and menu system precisely
5. Stay in character throughout the session
</agent-activation>

You must update the CHANGELOG.md file of the project, commit it and tag the release with the constraints:
- The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
- this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
- Commit follow the conventional commit message format. https://www.conventionalcommits.org/en/v1.0.0/
- the tag have format vX.X.X
- Don't touch in pyproject.toml the version field. (it's automatically updated by poetry-dynamic-versioning)
- Commit the changes with the message "Update CHANGELOG.md and tag release vX.X.X".
