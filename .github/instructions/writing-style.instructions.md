---
name: 'WritingStyle'
description: 'Guidelines for writing clear, professional, and accessible content.'
applyTo: '**/*.md'
---

# Writing Style Instructions

Unified style governance for all Markdown project documents. Provides actionable, verifiable guidance for clarity, consistency, and accessibility across general narrative, technical, and reference content.

## Role & Scope

**✅ Do:**

- **Provide a single source of truth** for all Markdown writing
- **Promote a professional yet conversational voice** (clear, direct, inclusive)
- **Support clear sectioning, concise paragraphs, and scannable lists**
- **Require evidence** (links, artifacts, examples) for measurable or technical claims
- **Encourage accessibility:** plain vocabulary, defined terms, inclusive phrasing
- **Avoid the curse of knowledge** - don't assume readers have prior knowledge
- **Make content self-sufficient** so readers don't need to ask clarifying questions

**🚫 Don't:**

- _Fragment style guidance_ across multiple ad‑hoc documents
- _Use speculative or unverifiable statements_ as fact
- _Over-formalize_ - avoid needlessly ornate or "posh" tone
- _Add filler bullets_ or redundant sentences
- _Introduce unnecessary categorization_ when a simple summary suffices

## Orchestration Workflow (Authoring Sequence)

**✅ Do (recommended order):**

1. **Clarify audience & purpose**
2. **Draft core ideas plainly** (active voice, simple structure)
3. **Organize with headings, short paragraphs** (≤4 sentences), and lists where helpful
4. **Add verification links** for claims referencing artifacts or results
5. **Run variation checks** (verb diversity, sentence length, abbreviation clarity, emoji restraint)
6. **Edit for clarity & conciseness** (remove jargon, shorten long sentences, trim redundancy)
7. **Apply the final quality checklist**

**🚫 Don't:**

- _Skip audience clarification_
- _Leave placeholder text_ ("TBD", "FIXME") in final documents
- _Paste raw data dumps_ without synthesis
- _Over-edit early drafts_ at the expense of idea completeness
- _Default to passive voice_ for key actions

## Writing Standards

### Language & Tone

**✅ Do:**

- **Use US English, active voice, accessible vocabulary** - contractions when natural
- **Trust your conversational voice** - use language that comes naturally
- **Write to express, not impress** - focus on clear thinking over vocabulary display
- **Allow one light, tongue‑in‑cheek aside** in non-sensitive contexts
- **Use emojis sparingly** inside bullets or category titles when they clarify tone or meaning
- **Expand common abbreviations** where clarity improves ("for example" over "e.g.", "versus" over "vs"); "e.g." and "vs" are acceptable when widely understood
- **Prefer full month names** (e.g., June 2025) in dated headings

**🚫 Don't:**

- _Place emojis_ in top‑level headings (#, ##, ###)
- _Use humor_ in sensitive contexts (security, personnel, risk incidents)
- _Overuse parenthetical asides_ or emotive punctuation
- _Substitute opinion for evidence_ on technical matters

### Clarity & Accessibility

**✅ Do:**

- **Define acronyms and technical terms** on first use
- **Break complex ideas** into short paragraphs (≤4 sentences)
- **Provide necessary context** - avoid hidden assumptions
- **Prefer specific nouns & decisive verbs** (avoid "do", "things")
- **Aim for transparency** - eliminate words or structures that call attention to themselves
- **Use simple sentence structures** to enhance readability

**🚫 Don't:**

- _Assume prior knowledge_ ("obviously", "clearly")
- _Bury key points_ deep in text blocks
- _Create long, unbroken walls of text_
- _Rely on unexplained internal jargon_

### Structure & Flow

**✅ Do:**

- **Follow Opening → Middle → Closing logic**
- **Lead sections with their main point** (inverted pyramid)
- **Use lists for multi-item clarity** - keep them parallel
- **Split or summarize lists** that grow unwieldy
- **Create smooth transitions** between sections and ideas
- **Use section overviews** to surface key points before details
- **Build in visual variety** - balance text with white space and formatting
- **Enable easy navigation** - help readers find key information quickly

**🚫 Don't:**

- _Mix unrelated concepts_ inside one bullet
- _Start many consecutive bullets_ with identical verbs
- _Leave headings_ without explanatory content
- _Nest excessive list levels_

### Sentence Construction

**✅ Do:**

- **Keep most sentences ≤25 words** - favor brevity
- **Place core information early** in the sentence
- **Use coordination ("and")** for complementary ideas; limit complex subordination
- **Use a primary factual sentence for results** - follow with additive evidence sentences (each ≤25 words)
- **Use personal pronouns judiciously** - avoid "I" in formal impact summaries; team or neutral voice preferred
- **Give yourself permission to use personal pronouns** (I, we, you) when appropriate for conversational flow
- **Use parallel structure** for items that serve the same function

**🚫 Don't:**

- Pad sentences with empty qualifiers ("very", "quite", "rather")
- Overuse passive voice ("was completed by")
- Chain multiple clauses creating >25-word density without clarity gain
- Repeat the same opening verb across successive bullets without reason

### Verification & Evidence

**✅ Do:**

- **Link any claim** referencing an artifact (issue, PR, code, dataset, training, spec)
- **Use canonical GitHub link format** `[owner/repo#number]` for issues/PRs
- **Italicize customer names** only in multi-customer lists
- **Spot-check link resolution** before finalizing

**🚫 Don't:**

- _Cite unverifiable internal claims_ without source
- _Leave placeholder links_ ("link forthcoming") unmarked
- _Duplicate artifact links_ in adjacent bullets without new dimension
- _Omit formatting_ for multi-customer references

### Conciseness & Variation

**✅ Do:**

- **Remove redundant phrases** ("each and every" → "every")
- **Replace wordy expressions** ("due to the fact that" → "because")
- **Vary verbs** across adjacent summary bullets
- **Prefer simpler terms** (Use, Help, Show, End, Get)

**🚫 Don't:**

- _Inflate language_ for sophistication
- _Recycle identical phrasing_ across related bullets
- _Leave filler sub-bullets_ that lack action or outcome
- _Stack identical opening verbs_ without necessity

### Editing Workflow

**✅ Do:**

- **Draft → refine → evidence links → variation check → final proof**
- **Edit for major issues while drafting** - but don't get stuck on perfect phrasing
- **Focus on getting ideas down clearly** during first draft
- **Let high-stakes documents rest** before final review (incubation period)
- **Print hard copy** for different perspective on important documents
- **Ask trusted colleague to review** high-stakes content
- **Run clarity and conciseness passes separately**
- **Use the checklist** before committing

**🚫 Don't:**

- _Over-polish first draft_ prematurely
- _Skip grammar/spell review_
- _Rely solely on automated tone tools_
- _Leave unresolved TODO markers_

## Document Structure

### Organization and Flow

**✅ Do:**

- **Follow the three-part structure:** Opening, Middle, Closing
- **Lead with key information** in each section
- **Use logical progression** from general to specific concepts
- **Create smooth transitions** between sections and ideas
- **End with clear next steps** or conclusions

**🚫 Don't:**

- _Jump between unrelated topics_ without transitions
- _Bury conclusions_ at the end
- _Leave readers_ without clear takeaways

### High Skim Value

Enhance documents for easy scanning by using:

**✅ Do:**

- **Use clear headings and subheadings** in a consistent hierarchy
- **Apply bulleted and numbered lists** for multiple items
- **Keep paragraphs short** (3-4 sentences maximum)
- **Use bold text** for key terms and important points
- **Include white space** to separate sections and improve readability
- **Provide section overviews** that surface key points before diving into details
- **Lead each section with its main point** (conclusion orientation)
- **Use advance organizers** to guide readers through your logic (coherence cues)

**🚫 Don't:**

- _Create long, dense paragraphs_
- _Overuse formatting_ that reduces clarity
- _Neglect visual hierarchy_

## Writing Standards

## Tone & Style Flexibility

**✅ Do:**

- **Favor conversational clarity** over rigid formality
- **Use one tasteful emoji** when it improves scanability or tone
- **Allow reflective clause** in learning contexts (paired with factual content)
- **Adjust tone to topic sensitivity** (neutral for security/risk)

**🚫 Don't:**

- _Force humor_ into sensitive topics
- _Cluster multiple emojis_ in a single bullet
- _Replace evidence_ with emotional reaction
- _Use sarcasm_ that risks misinterpretation

## Document Design & Visual Elements

**✅ Do:**

- **Use conventional formatting** - documents should look as expected for their type
- **Maintain consistent styling** across all project documents
- **Choose readable fonts and sizes** (typically 11-12pt for body text)
- **Use appropriate margins and spacing**
- **Apply consistent bullet styles and indentation**
- **Create visually inviting documents** - avoid long paragraphs and uninterrupted text blocks

**🚫 Don't:**

- _Mix inconsistent formatting styles_ within a document
- _Use unusual fonts_ that distract from content
- _Create dense text blocks_ without visual breaks
- _Neglect proper spacing and margins_

### Professional Standards

**✅ Do:**

- **Proofread all content** for spelling, grammar, and logic
- **Maintain consistent terminology** throughout the project
- **Use parallel structure** in lists and headings
- **Follow standard punctuation rules**
- **Ensure proper capitalization** of proper nouns and titles

**🚫 Don't:**

- _Allow typos or grammatical errors_ to slip through
- _Switch terminology_ mid-document
- _Mix formatting styles_ inconsistently

## Specific Language Guidelines

### Word Choice

**✅ Use these preferred terms:**

- "Use" instead of "utilize"
- "Help" instead of "assist" or "facilitate"
- "Show" instead of "demonstrate" or "illustrate"
- "Start" instead of "commence" or "initiate"
- "End" instead of "terminate" or "conclude"
- "Get" instead of "obtain" or "acquire"

**🚫 Avoid:**

- _Unnecessarily complex vocabulary_ when simpler words suffice
- _Business jargon or buzzwords_ without clear meaning
- _Overly technical terms_ when writing for general audiences

## Writing Style Management

### Common Phrasing Issues to Avoid

**Passive Voice Overuse:**

- Use active voice to show who's doing what
- Reserve passive voice for when the actor is unknown or unimportant
- Example: "The team completed the project" (not "The project was completed by the team")

**Wordy Expressions:**

- "Due to the fact that" → "Because"
- "At that point in time" → "Then"
- "Make a decision about" → "Decide"
- "Came to the conclusion that" → "Concluded"

**Unnecessary Repetition:**

- Avoid doublets: "each and every" → "every"
- Cut obvious statements: Don't start with "First of all"
- Eliminate redundant phrases: "five-year period" → "five years"

## Content-Specific Guidelines

### Technical Writing

**✅ Do:**

- **Explain acronyms** on first use
- **Use examples** to clarify abstract concepts
- **Include context** for technical decisions
- **Write step-by-step instructions** for procedures
- **Test instructions** to ensure they're complete

**🚫 Don't:**

- _Assume all readers have the same technical background_
- _Skip essential steps_ in procedures
- _Use jargon_ without explanation

### Academic (and Course) Content

**✅ Do:**

- **Connect new concepts** to previously learned material
- **Use real-world examples** to illustrate theoretical points
- **Provide multiple explanations** for complex topics
- **Include reflection questions** to engage readers
- **Reference source materials** appropriately

**🚫 Don't:**

- _Present theory_ without practical application
- _Assume prior knowledge_ without checking
- _Omit citations or references_

## Structured Summary Bullets (Optional)

Use only when summarizing aggregated progress, decisions, or forward actions; otherwise rely on standard prose.

**✅ Do:**

- **Keep any summary bullet succinct** (≤5 sentences) OR use a sub-list (≤5 sub-bullets, each ≤20 words) for distinct facets
- **Begin sub-bullets with a verb** or concise noun phrase; link artifacts for measurable outcomes
- **Vary opening verbs** for adjacent bullets to maintain readability
- **Keep forward-looking items concrete** (next steps, owners, timelines)

**🚫 Don't:**

- _Invent specialized labels_ if a neutral "Summary" heading suffices
- _Exceed length caps_ without added clarity
- _Use speculative language_ in past-oriented summaries
- _Repeat or empty sub-bullets_

## Tone Management & Reader Relationships

### Formality & Tone Adjustment

**✅ Do:**

- **Choose appropriate formality level** based on audience, topic sensitivity, and context
- **For softer tone:** Use phrases like "You might consider..." or "Might I suggest..."
- **For neutral tone:** State facts directly and clearly
- **For emphasis:** Use specific, concrete language
- **Select neutral words** over emotionally charged alternatives
- **Be mindful of connotations** and implied judgments
- **Adapt vocabulary** to your audience's expertise level

**🚫 Don't:**

- _Use overly formal language_ when conversational tone is appropriate
- _Choose emotionally loaded words_ when neutral alternatives exist
- _Assume one tone fits all contexts_

### Reader Focus & Credibility

**✅ Do:**

- **Consider your audience's needs** and expectations
- **Address reader concerns** proactively
- **Use inclusive language** that welcomes all readers
- **Maintain respectful tone** throughout
- **Acknowledge different perspectives** when relevant
- **Support claims with evidence** or examples
- **Acknowledge limitations** honestly
- **Use confident but not arrogant language**
- **Maintain consistency** in facts and figures
- **Follow through on promised information**

**🚫 Don't:**

- _Ignore audience concerns_ or questions
- _Use exclusive or alienating language_
- _Make unsupported claims_
- _Overstate capabilities_ or knowledge
- _Promise information_ without delivering

## Editing and Revision Process

### Systematic Review Approach

**While drafting:**

- Edit for major issues as you write
- Don't get stuck on perfect phrasing during first draft
- Focus on getting ideas down clearly

**After drafting:**

- Review for content completeness and logic
- Check for clarity and reader understanding
- Verify tone appropriateness
- Proofread for grammar, spelling, and mechanics

**For high-stakes documents:**

- Let document rest before final review (incubation period)
- Print hard copy for different perspective
- Ask trusted colleague to review
- Do final proofread after all changes

### Common Editing Targets

**Clarity improvements:**

- Replace complex words with simpler alternatives
- Break up long sentences (over 25 words)
- Eliminate jargon without explanation
- Add transitions between ideas

**Conciseness improvements:**

- Remove unnecessary qualifiers
- Eliminate wordy phrases
- Cut redundant information
- Combine related points efficiently

## Extended Guidelines

Apply specialized agent instructions from `@github.writing-style.instructions.md` (if present and accessible) on top of these core guidelines where relevant.

## Final Quality Checklist

**✅ Do verify:**

- [ ] **Content is self-sufficient and complete** - no curse of knowledge assumptions
- [ ] **Audience assumptions removed** - context self-sufficient
- [ ] **US English spelling and grammar** are correct throughout
- [ ] **Content flows logically** from opening to closing
- [ ] **High skim value** through clear structure and formatting
- [ ] **Sections logically ordered** - headings populated
- [ ] **Document follows conventional format** for its type
- [ ] **Sentences and any summary bullets within length limits** - verbs varied
- [ ] **Passive voice minimized** - decisive verbs prevalent
- [ ] **Redundant phrases removed** - simpler terms applied
- [ ] **Inclusive & accessible language present** - problematic terms absent
- [ ] **All artifact claims have working links**
- [ ] **No speculation in past summaries** - forward actions clearly scoped
- [ ] **Examples support key points** where provided
- [ ] **Technical examples** (if present) minimal, accurate, runnable
- [ ] **Headlines direct, sentence case, value‑forward**
- [ ] **Abbreviations expanded** where clarity improves; domain (e.g. PR, JSON) preserved
- [ ] **Emojis additive** - none in top-level headings

**🚫 Don't leave unresolved:**

- [ ] _Unverified claims_ lacking artifact, data, or example
- [ ] _Overlong paragraphs_ (>4 sentences) or dense walls of text
- [ ] _Consecutive identical opening verbs_ without necessity
- [ ] _Unnecessary categorization_ where a simple summary works
- [ ] _Broken or placeholder links_

---

_These unified guidelines ensure writing remains clear, professional, accessible, and verifiably useful across all documentation._
