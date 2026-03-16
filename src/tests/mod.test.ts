import { assertEquals } from "jsr:@std/assert";
import { generatedVersion } from "../version.ts";

Deno.test("generatedVersion matches deno.json", async () => {
  const raw = await Deno.readTextFile("deno.json");
  const config = JSON.parse(raw);
  assertEquals(generatedVersion, config.version);
});

Deno.test("generatedVersion is a semver string", () => {
  const semverish = /^v?\d+\.\d+\.\d+/;
  assertEquals(semverish.test(generatedVersion), true);
});
