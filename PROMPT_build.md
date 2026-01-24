0a. Study `specs/README.md` and linked files to learn the application specifications.
0b. Study `plans/README.md` and linked files to learn the plans.

1. Your task is to implement functionality per the specifications. Follow `plans/README.md` and choose the most important item to address. Choose one item, and one item only, to complete. Do not ask me for permission, just do it. Only complete that one item, and then stop (don't try to do too much in one session). Before making changes, search the codebase (don't assume not implemented).
2. After implementing functionality or resolving problems, run the tests for that unit of code that was improved. If functionality is missing then it's your job to add it as per the application specifications.
3. When you discover issues, immediately update `plans/*` with your findings. When resolved, update and remove the item.
4. When the tests pass, update `plans/*` (always keep those files updated!), then `git add -A` then `git commit` in a subagent with a message describing the changes.
5. Before finishing up, make sure any servers you ran are stopped/killed, and `docker compose down`.

99999. Important: When authoring documentation, capture the why — tests and implementation importance.
999999. Important: Single sources of truth, no migrations/adapters. If tests unrelated to your work fail, resolve them as part of the increment.
9999999. As soon as there are no build or test errors create a git tag. If there are no git tags start at 0.0.0 and increment patch by 1 for example 0.0.1  if 0.0.0 does not exist.
99999999. You may add extra logging if required to debug issues.
999999999. Keep `plans/*` current with learnings using a subagent — future work depends on this to avoid duplicating efforts. Update especially after finishing your turn.
9999999999. When you learn something new about how to run the application, update @CLAUDE.md using a subagent but keep it brief. For example if you run commands multiple times before learning the correct command then that file should be updated.
99999999999. For any bugs you notice, resolve them or document them in `plans/*` using a subagent even if it is unrelated to the current piece of work.
999999999999. Implement functionality completely. Placeholders and stubs waste efforts and time redoing the same work.
9999999999999. When `plans/README.md` becomes large periodically clean out the items that are completed from the file using a subagent.
99999999999999. If you find inconsistencies in the specs/* then use an Opus 4.5 subagent with 'ultrathink' requested to update the specs.
999999999999999. IMPORTANT: Keep @CLAUDE.md operational only — status updates and progress notes belong in `plans/*`. A bloated CLAUDE.md pollutes every future loop's context.
