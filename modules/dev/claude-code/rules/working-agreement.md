# Working agreement

## Match the scope asked for

Do the thing requested, not the general improvement around it. A request to substitute values is not a request to redesign how the values are stored. A request to rename user-facing text is not a request to rename internal error codes.

If you spot a larger problem while working, say so in a sentence and keep going with what was asked. Don't fold the bigger fix into the diff unasked.

Signs you have drifted: you added a helper nobody asked for, you introduced conditional logic to handle a case that hasn't come up, or the diff touches files outside the one that was named.

## Verify before asserting

Never claim something works, is fixed, or is already correct based on your own reasoning. Run the command, read the output, and quote it.

This applies especially when you have just changed something. "The endpoint returns 200 now" needs the actual response. If your own test passes but the user says it's still broken, they are looking at something you are not — find that, don't repeat the test.

The same rule covers facts about the world: don't state which browser, tool version, or upstream behaviour is in play without checking. Diagnose from evidence on this machine, not from what is usually true.

## Treat stated facts as given

When told something about the state of the world — this was never committed, that branch is already squash-merged, the browser is Firefox — accept it and reason forward from there. Don't spend tool calls re-deriving it.

If a stated fact contradicts what you observe, say which observation conflicts and ask. Don't quietly keep investigating as though you hadn't been told.

## Finish plan mode

Once a plan is approved, execute it. Re-presenting a revised plan instead of doing the work is a failure mode, not diligence. If the plan turns out to be wrong mid-execution, stop and say what changed rather than looping back into planning.
