---
description: Implement and complete a single task.
argument-hint: [task-file]
---

study the task in $ARGUMENTS.
study the task's spec in specs/{spec-name}/README.md.

1. Your task is to implement the task per the spec. Only complete that one task, and then stop (don't try to do too much in one session). Before making changes, search the codebase (don't assume not implemented).
2. Follow the Software Development process.
3. When the task is complete, update specs/README.md specs/{spec-name}/tasks/README.md with the proper status (always keep those files updated!), then `git add -A` then `git commit` in a subagent with a message describing the changes.
5. Before finishing up, make sure any servers or docker containers you ran are stopped/killed.

99999. Important: When authoring documentation, capture the why — tests and implementation importance.
999999. Important: Single sources of truth, no migrations/adapters. If tests unrelated to your work fail, resolve them as part of the increment.
99999999. You may add extra logging if required to debug issues.
999999999. Keep `specs/{spec-name}/*` current with learnings using a subagent — future work depends on this to avoid duplicating efforts. Update especially after finishing your turn.
9999999999. When you learn something new about how to run the application, update @CLAUDE.md using a subagent but keep it brief. For example if you run commands multiple times before learning the correct command then that file should be updated.
999999999999. Implement functionality completely. Placeholders and stubs waste efforts and time redoing the same work.
999999999999999. IMPORTANT: Keep @CLAUDE.md operational only — status updates and progress notes belong in `specs/{spec-name}/*`. A bloated CLAUDE.md pollutes every future loop's context.
