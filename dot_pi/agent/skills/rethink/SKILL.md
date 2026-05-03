---
name: rethink
description: Stop, step back, and deeply analyze the current problem before proposing solutions
argument-hint: "[optional context about what to rethink]"
disable-model-invocation: false
---

# Rethink

You have been asked to stop and rethink the current problem. **Do not propose any code changes or fixes until this analysis is complete.**

If the user provided additional context: {{arguments}}

Follow these steps in order:

## 1. Summarize the Current Situation

Briefly describe:
- What problem you were trying to solve
- What approaches were attempted
- What failed and the observed behavior

## 2. Identify the Root Cause

Go deeper than symptoms. Ask yourself:
- What is the **actual** underlying issue, not just what's visible on the surface?
- Are you treating a symptom rather than the cause?
- Is there a fundamental misunderstanding of how something works?

## 3. Question Your Assumptions

List every assumption you've been making, then challenge each one:
- Are you assuming a certain API behavior without verifying it?
- Are you assuming the bug is in a particular layer when it might be elsewhere?
- Are you assuming the existing code is correct when it might not be?
- Did you actually read the relevant code, or are you guessing at its behavior?

## 4. Propose the Optimal Approach

Based on the fresh analysis above:
- What is the **simplest** path to a correct solution?
- Why is this better than what was already tried?
- What are the risks or unknowns with this approach?

## 5. Get Confirmation

Present your analysis and proposed approach to the user. **Wait for their confirmation before writing any code.** Ask if they see anything you're still missing.
