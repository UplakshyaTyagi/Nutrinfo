# Design System Document: The Luminous Bento

## 1. Overview & Creative North Star: "The Digital Vitalist"
This design system moves beyond the cold, clinical nature of traditional health apps to create a high-end, editorial experience. The Creative North Star is **"The Digital Vitalist"**—a philosophy that treats data as something living, breathing, and premium. 

By leveraging a **Bento Box** grid structure, we move away from standard vertical scrolling lists in favor of intentional, modular storytelling. We break the "SaaS template" look through:
*   **Intentional Asymmetry:** Using varying Bento cell spans (e.g., a 2x2 cell next to a 1x1 cell) to create visual rhythm.
*   **Glassmorphism Layering:** High-end nutrition tracking isn't flat; it’s layered. Elements float on frosted glass, suggesting depth and "nutritional transparency."
*   **Kinetic Contrast:** Pairing the deep, muted charcoal backgrounds with "electric" accents to mimic the energy boost of proper nutrition.

---

## 2. Colors & Surface Architecture
The palette is rooted in a deep, sophisticated charcoal base, punctuated by high-frequency neons.

### Core Palette
*   **Surface (Background):** `#131313` (Deep Charcoal). Never use `#000000`.
*   **Primary (Mint):** `#00FF7F` (The "Electric Mint"). Used for growth, health, and primary actions.
*   **Secondary (Cyan):** `#00BFFF` (The "Vitality Blue"). Used for hydration, data visualization, and secondary accents.
*   **Text:** `on_surface` (`#e5e2e1`) for high-readability headers; `on_surface_variant` (`#b9cbb8`) for supportive, silver-toned metadata.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to section content. Boundaries must be defined solely through:
1.  **Background Color Shifts:** A `surface_container_low` card sitting on a `surface` background.
2.  **Tonal Transitions:** Using the hierarchy of `surface_container` tokens to create natural separation.

### The "Glass & Gradient" Rule
Floating panels (Bento cells) must utilize Glassmorphism. Apply a 20-40px `BackdropFilter` blur with a semi-transparent `surface_container_high` fill. To provide "soul," primary CTAs should utilize a subtle linear gradient from `primary_fixed` to `primary_container` (Mint to Deep Mint) at a 135-degree angle.

---

## 3. Typography: Editorial Sans
We pair **Manrope** (Display/Headlines) with **Inter** (Body/UI) to create a sophisticated, high-performance aesthetic.

| Level | Token | Font | Size | Character |
| :--- | :--- | :--- | :--- | :--- |
| **Display** | `display-lg` | Manrope | 3.5rem | Bold, tight tracking (-2%). |
| **Headline** | `headline-md` | Manrope | 1.75rem | Semi-bold. High-impact stats. |
| **Title** | `title-lg` | Inter | 1.375rem | Medium. Bento cell headers. |
| **Body** | `body-md` | Inter | 0.875rem | Regular. Crisp silver text. |
| **Label** | `label-md` | Inter | 0.75rem | All-caps, tracked out (+5%). |

---

## 4. Elevation & Depth: The Layering Principle
Hierarchy is achieved through **Tonal Layering** and **Ambient Shadows** rather than structural lines.

*   **Stacking Tiers:** Place a `surface_container_highest` element (like a modal or active chip) over a `surface_container_low` background. This creates a soft, physical lift.
*   **Ambient Floating:** For floating Bento cells, use the "soft, unblurred" shadow request by applying a shadow with a large spread but 0-4px blur, set to 6% opacity of the `on_surface` color. This creates a "cut-out" depth effect popular in modern editorial design.
*   **The Ghost Border Fallback:** If a container requires more definition, use a `1px` stroke of `outline_variant` at **15% opacity**. Never use 100% opaque strokes.

---

## 5. Components: Fluid & Frictionless

### Bento Cells (Cards)
*   **Radius:** `xl` (3rem/48px) for outer dashboard containers; `lg` (2rem/32px) for internal cells.
*   **Spacing:** Use `spacing-6` (2rem) for internal padding to ensure "breathing room."
*   **Interaction:** On hover, a Bento cell should scale 101% and increase its `BackdropFilter` blur intensity.

### Pill Buttons (Primary)
*   **Shape:** `full` (9999px).
*   **Color:** `primary_container` (#00FF7F).
*   **Typography:** `title-sm` (Inter, Bold).
*   **Styling:** Large, generous horizontal padding (`spacing-8`). No shadows; use a slight outer glow (2px) using the `primary` color at 20% opacity.

### Data Visualization (Nutrition Graphs)
*   **Forbid Dividers:** Do not use grid lines in charts. Use the `surface_container_lowest` background to let the data "float."
*   **Accents:** Use `primary` (Mint) for "Consumed" data and `secondary` (Cyan) for "Target" data.

### Input Fields
*   **Style:** Minimalist. No bottom line or box border. Use a `surface_container_high` pill-shaped background with `24px` (md) corners.
*   **Active State:** The background shifts to `surface_bright` with a 1px "Ghost Border" of the Primary Mint.

---

## 6. Do’s and Don’ts

### Do:
*   **DO** use whitespace as a separator. If elements look crowded, increase the `spacing` scale rather than adding a line.
*   **DO** use high-contrast typography scales. A 3.5rem `display-lg` header next to a 0.875rem `body-md` caption creates a premium, high-end feel.
*   **DO** use semi-transparency. Let the deep charcoal background bleed through your glass panels.

### Don't:
*   **DON'T** use pitch black (#000000). It kills the "frosted glass" depth effect.
*   **DON'T** use sharp corners. Everything in this system must feel organic and "frictionless." Minimum radius is 16px (sm).
*   **DON'T** use standard "Drop Shadows" with black. Shadows must be tinted with the background hue to maintain a "clean" dark mode.