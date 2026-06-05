# Agent Coordinator

You have access to **276 specialist agents** installed in `~/.claude/agents/`. You MUST actively use them via the Agent tool to delegate work to the right specialist. Do not attempt tasks yourself when a specialist agent exists — spawn it.

## How to Use Agents

Invoke any agent by spawning it with the Agent tool and referencing its name:
```
Agent tool → prompt: "Use @agent-name to [task description]"
```

## When to Delegate (ALWAYS)

Before doing any substantive work, check this index for the right agent. If a match exists, **spawn it**. If the task spans multiple domains, spawn the `agents-orchestrator` to coordinate, or spawn multiple agents in parallel.

---

## Agent Index by Domain

### Engineering & Development
| Agent | Use When |
|-------|----------|
| `engineering-senior-developer` | General implementation, premium code |
| `engineering-frontend-developer` | React, Vue, Angular, CSS, UI code |
| `engineering-backend-architect` | APIs, server-side, system design |
| `engineering-software-architect` | Architecture decisions, system design |
| `engineering-code-reviewer` | Code review, quality checks |
| `code-simplifier` | Post-write code refinement — clarity, consistency, maintainability (Anthropic official) |
| `engineering-codebase-onboarding-engineer` | Understanding new codebases |
| `engineering-database-optimizer` | SQL, schema, query optimization |
| `engineering-data-engineer` | Data pipelines, ETL, warehousing |
| `engineering-devops-automator` | CI/CD, infrastructure, Docker, K8s |
| `engineering-sre` | Reliability, monitoring, SLOs |
| `engineering-security-engineer` | Security audits, hardening |
| `engineering-mobile-app-builder` | iOS, Android, React Native, Flutter |
| `engineering-rapid-prototyper` | Fast MVPs and proof-of-concepts |
| `engineering-minimal-change-engineer` | Surgical fixes, minimal diffs |
| `engineering-git-workflow-master` | Git strategy, branching, rebasing |
| `engineering-technical-writer` | Technical docs, API docs |
| `engineering-ai-engineer` | ML models, AI integration |
| `engineering-ai-data-remediation-engineer` | Data quality, cleanup |
| `engineering-cms-developer` | CMS platforms, content systems |
| `engineering-email-intelligence-engineer` | Email systems, deliverability |
| `engineering-embedded-firmware-engineer` | Firmware, IoT, embedded |
| `engineering-voice-ai-integration-engineer` | Voice AI, speech systems |
| `engineering-solidity-smart-contract-engineer` | Solidity, Ethereum, Web3 |
| `engineering-wechat-mini-program-developer` | WeChat mini programs |
| `engineering-feishu-integration-developer` | Feishu/Lark integrations |
| `engineering-filament-optimization-specialist` | Laravel Filament |
| `engineering-incident-response-commander` | Incident management |
| `engineering-threat-detection-engineer` | Threat detection, SIEM |
| `engineering-autonomous-optimization-architect` | Self-optimizing systems |

### Testing & QA
| Agent | Use When |
|-------|----------|
| `testing-reality-checker` | Final validation, evidence-based QA |
| `testing-evidence-collector` | Screenshot-based testing evidence |
| `testing-api-tester` | API endpoint testing |
| `testing-performance-benchmarker` | Performance testing, load testing |
| `testing-accessibility-auditor` | WCAG, a11y audits |
| `testing-test-results-analyzer` | Analyzing test results |
| `testing-tool-evaluator` | Evaluating tools and platforms |
| `testing-workflow-optimizer` | Process optimization |

### Design & UX
| Agent | Use When |
|-------|----------|
| `design-ui-designer` | Visual design, component libraries |
| `design-ux-architect` | UX architecture, CSS systems |
| `design-ux-researcher` | User research, usability |
| `design-brand-guardian` | Brand consistency, identity |
| `design-visual-storyteller` | Visual narratives |
| `design-image-prompt-engineer` | AI image generation prompts |
| `design-inclusive-visuals-specialist` | Diverse, unbiased visuals |
| `design-whimsy-injector` | Delight, personality, fun |

### Marketing
| Agent | Use When |
|-------|----------|
| `marketing-content-creator` | Content strategy, copywriting |
| `marketing-seo-specialist` | SEO audits, optimization |
| `marketing-growth-hacker` | Growth experiments, acquisition |
| `marketing-social-media-strategist` | Social strategy |
| `marketing-twitter-engager` | Twitter/X content |
| `marketing-linkedin-content-creator` | LinkedIn posts |
| `marketing-instagram-curator` | Instagram strategy |
| `marketing-tiktok-strategist` | TikTok content |
| `marketing-reddit-community-builder` | Reddit engagement |
| `marketing-podcast-strategist` | Podcast planning |
| `marketing-video-optimization-specialist` | Video SEO |
| `marketing-app-store-optimizer` | ASO, app store |
| `marketing-book-co-author` | Book writing |
| `marketing-carousel-growth-engine` | Carousel content |
| `marketing-agentic-search-optimizer` | AI search optimization |
| `marketing-ai-citation-strategist` | AI citation building |
| `marketing-short-video-editing-coach` | Short-form video |
| `marketing-livestream-commerce-coach` | Live selling |
| `marketing-private-domain-operator` | Private traffic |

### SEO (Claude SEO)
| Agent | Use When |
|-------|----------|
| `seo-technical` | Crawlability, indexability, security audits |
| `seo-content` | E-E-A-T, readability, thin content analysis |
| `seo-schema` | Schema.org structured data validation |
| `seo-sitemap` | Sitemap quality gates and analysis |
| `seo-performance` | Core Web Vitals, page speed |
| `seo-visual` | Screenshots, mobile rendering checks |
| `seo-geo` | AI crawler access, GEO, citability |
| `seo-local` | GBP, NAP, citations, reviews, local schema |
| `seo-maps` | Geo-grid, GBP audit, reviews, competitor radius |
| `seo-google` | Google API analyst (CrUX, GSC, GA4) |
| `seo-backlinks` | Backlink profile analysis (Moz, Bing, CC) |
| `seo-dataforseo` | DataForSEO live data analyst |
| `seo-image-gen` | SEO image audit analyst |
| `seo-cluster` | Semantic keyword clustering |
| `seo-sxo` | Search experience optimization |
| `seo-drift` | SEO drift / regression monitoring |
| `seo-ecommerce` | E-commerce SEO analysis |
| `seo-flow` | FLOW framework prompt analyst |

### Blog (Claude Blog)
| Agent | Use When |
|-------|----------|
| `blog-writer` | Draft generation, outline creation, 12 content templates |
| `blog-researcher` | Sourcing, fact-checking, discourse analysis, NotebookLM |
| `blog-reviewer` | BLOCKING QA gate — 5-category 100-point rubric scoring |
| `blog-seo` | Post-write SEO validation and optimization |
| `blog-translator` | SEO-optimized translation and cultural localization |

### Healthcare & Medical
| Agent | Use When |
|-------|----------|
| `health-insights-agent` | Analyze medical reports, lab results, health data |
| `medical-research-agent` | Medical literature search, clinical trial research |
| `health-insurance-claims-agent` | Insurance claim workflows, ICD-10/CPT validation |
| `patient-intake-agent` | Patient intake forms, data validation, profiles |
| `clinical-protocol-agent` | Clinical protocol review, compliance auditing |

### Finance & Trading
| Agent | Use When |
|-------|----------|
| `stock-analysis-agent` | Stock market analysis, financial statements, signals |
| `trading-strategy-agent` | Trading strategy design, technical indicators, backtesting |
| `financial-report-agent` | P&L, cash flow, balance sheet reports |
| `budget-planning-agent` | Budget plans, cost forecasting, savings analysis |
| `crypto-analysis-agent` | Cryptocurrency markets, on-chain metrics, DeFi |
| `invoice-processing-agent` | Invoice data extraction, PO matching, payment scheduling |

### Education & Research
| Agent | Use When |
|-------|----------|
| `virtual-tutor-agent` | Personalized tutoring, step-by-step explanations |
| `study-partner-agent` | Flashcards, quizzes, spaced repetition, study plans |
| `curriculum-designer-agent` | Course curricula, learning paths, lesson plans |
| `research-scholar-agent` | Academic literature search, annotated bibliographies |
| `essay-grading-agent` | Essay evaluation, rubric scoring, feedback |

### Data & Analytics
| Agent | Use When |
|-------|----------|
| `data-visualization-agent` | Charts, graphs, matplotlib/plotly/D3 code |
| `sql-query-agent` | Natural language to SQL, query optimization |
| `data-extraction-agent` | Extract structured data from unstructured sources |
| `data-cleaning-agent` | Duplicates, missing values, outliers, format fixes |
| `report-generator-agent` | Business reports, KPI dashboards, trend analysis |
| `web-scraping-agent` | Web scraping scripts, pagination, anti-bot handling |

### Productivity & Planning
| Agent | Use When |
|-------|----------|
| `email-auto-responder-agent` | Draft email responses, classify incoming emails |
| `meeting-assistant-agent` | Agendas, notes, action items, follow-ups |
| `trip-planner-agent` | Travel itineraries, budget estimates, day-by-day plans |
| `event-planner-agent` | Event coordination, vendor checklists, run-of-show |
| `personal-productivity-agent` | Workflow analysis, time management, goal tracking |
| `knowledge-base-agent` | Organize, index, and retrieve knowledge bases |

### E-commerce & Retail
| Agent | Use When |
|-------|----------|
| `product-recommendation-agent` | Product recommendations, collaborative filtering |
| `personal-shopper-agent` | Virtual shopping assistant, curated lists |
| `pricing-strategy-agent` | Competitor pricing, dynamic pricing, elasticity |
| `inventory-optimization-agent` | Demand forecast, reorder points, safety stock |
| `product-listing-agent` | Optimized listings for Amazon, Shopify, e-commerce |

### Creative & Content
| Agent | Use When |
|-------|----------|
| `book-writing-agent` | Book outlines, chapter drafts, editorial feedback |
| `screenplay-writer-agent` | Screenplays in industry format, three-act structure |
| `social-media-post-agent` | Platform-optimized social posts (IG, X, LinkedIn, TikTok) |
| `landing-page-agent` | High-converting landing page copy and HTML |
| `recipe-creator-agent` | Personalized recipes, dietary restrictions, scaling |
| `content-repurposer-agent` | Transform content across formats (blog→social, etc.) |

### Industry-Specific (500-AI)
| Agent | Use When |
|-------|----------|
| `property-pricing-agent` | Real estate valuation, market trends, comps |
| `smart-farming-agent` | Crop health, yield predictions, pest identification |
| `energy-forecasting-agent` | Energy demand prediction, efficiency recommendations |
| `manufacturing-monitor-agent` | Production metrics, OEE, quality control |
| `logistics-optimization-agent` | Route optimization, warehouse, supply chain |
| `threat-detection-agent` | Cybersecurity threat analysis, log analysis |
| `movie-recommendation-agent` | Personalized movie/TV recommendations |
| `book-recommendation-agent` | Book recommendations, reading lists |

### AI/ML Workflows
| Agent | Use When |
|-------|----------|
| `code-debugging-agent` | Root cause analysis, error traces, bug fixes |
| `code-generation-agent` | Generate production code from natural language |
| `ml-pipeline-agent` | ML pipeline design, training, evaluation |
| `agent-builder-agent` | Meta-agent: designs and creates other agents |
| `prompt-engineering-agent` | Craft, test, optimize LLM prompts |
| `rag-pipeline-agent` | RAG system design, chunking, embeddings, retrieval |
| `model-evaluation-agent` | ML model evaluation, metrics, bias detection |

### Sales & Marketing (500-AI)
| Agent | Use When |
|-------|----------|
| `lead-scoring-agent` | Lead evaluation, priority tiers, next-best-action |
| `marketing-strategy-agent` | Marketing strategy, channel mix, budget allocation |
| `competitive-intelligence-agent` | Competitor analysis, battle cards, SWOT |
| `email-campaign-agent` | Email campaigns, A/B testing, drip sequences |
| `customer-feedback-agent` | Feedback analysis, sentiment, feature requests |
| `job-posting-agent` | Job descriptions, salary benchmarks, compliance |

### Operations & DevOps (500-AI)
| Agent | Use When |
|-------|----------|
| `markdown-validator-agent` | Markdown linting, broken links, structure validation |
| `api-design-agent` | REST/GraphQL API design, OpenAPI specs |
| `readme-generator-agent` | Generate READMEs from codebase analysis |
| `changelog-agent` | Generate changelogs from git history |
| `migration-agent` | Code migrations, framework upgrades, rollback plans |
| `config-audit-agent` | Audit Docker, K8s, Terraform, nginx configs |
| `dependency-audit-agent` | Dependency vulnerabilities, license compliance |
| `media-trend-agent` | Emerging media trends, viral content analysis |

### Marketing (China)
| Agent | Use When |
|-------|----------|
| `marketing-baidu-seo-specialist` | Baidu SEO |
| `marketing-bilibili-content-strategist` | Bilibili |
| `marketing-douyin-strategist` | Douyin/TikTok China |
| `marketing-kuaishou-strategist` | Kuaishou |
| `marketing-wechat-official-account` | WeChat content |
| `marketing-weibo-strategist` | Weibo |
| `marketing-xiaohongshu-specialist` | Xiaohongshu/RED |
| `marketing-zhihu-strategist` | Zhihu |
| `marketing-china-ecommerce-operator` | China e-commerce |
| `marketing-china-market-localization-strategist` | China localization |
| `marketing-cross-border-ecommerce` | Cross-border commerce |

### Paid Media & Advertising
| Agent | Use When |
|-------|----------|
| `paid-media-ppc-strategist` | Google Ads, PPC |
| `paid-media-paid-social-strategist` | Paid social campaigns |
| `paid-media-creative-strategist` | Ad creative strategy |
| `paid-media-programmatic-buyer` | Programmatic ads |
| `paid-media-auditor` | Ad account audits |
| `paid-media-search-query-analyst` | Search query analysis |
| `paid-media-tracking-specialist` | Conversion tracking, pixels |

### Product Management
| Agent | Use When |
|-------|----------|
| `product-manager` | Product strategy, roadmap |
| `product-sprint-prioritizer` | Sprint planning, backlog |
| `product-feedback-synthesizer` | User feedback analysis |
| `product-trend-researcher` | Market trends, competitive analysis |
| `product-behavioral-nudge-engine` | Behavioral design, nudges |

### Project Management
| Agent | Use When |
|-------|----------|
| `project-manager-senior` | Spec-to-task conversion |
| `project-management-project-shepherd` | Cross-functional coordination |
| `project-management-studio-producer` | Multi-project portfolio |
| `project-management-studio-operations` | Day-to-day ops |
| `project-management-experiment-tracker` | A/B tests, experiments |
| `project-management-jira-workflow-steward` | Jira workflows |

### Sales
| Agent | Use When |
|-------|----------|
| `sales-outbound-strategist` | Outbound sales strategy |
| `sales-outreach` | Cold outreach, emails |
| `sales-discovery-coach` | Discovery calls |
| `sales-deal-strategist` | Deal negotiation |
| `sales-pipeline-analyst` | Pipeline analysis |
| `sales-account-strategist` | Account planning |
| `sales-proposal-strategist` | Proposal writing |
| `sales-coach` | Sales training |
| `sales-engineer` | Technical sales |
| `sales-data-extraction-agent` | Sales data extraction |

### Finance
| Agent | Use When |
|-------|----------|
| `finance-financial-analyst` | Financial analysis |
| `finance-fpa-analyst` | FP&A, forecasting |
| `finance-bookkeeper-controller` | Bookkeeping, accounting |
| `finance-investment-researcher` | Investment research |
| `finance-tax-strategist` | Tax planning |
| `accounts-payable-agent` | Payment processing |

### Support & Operations
| Agent | Use When |
|-------|----------|
| `support-support-responder` | Customer support |
| `support-analytics-reporter` | Analytics, dashboards |
| `support-executive-summary-generator` | Executive summaries |
| `support-finance-tracker` | Financial tracking |
| `support-infrastructure-maintainer` | Infrastructure ops |
| `support-legal-compliance-checker` | Legal compliance |
| `customer-service` | General customer service |

### Game Development
| Agent | Use When |
|-------|----------|
| `game-designer` | Game design, mechanics |
| `game-audio-engineer` | Game audio |
| `level-designer` | Level design |
| `narrative-designer` | Story, dialogue |
| `technical-artist` | Tech art pipeline |

### Game Engines
| Agent | Use When |
|-------|----------|
| `unity-architect` | Unity architecture |
| `unity-editor-tool-developer` | Unity editor tools |
| `unity-multiplayer-engineer` | Unity multiplayer |
| `unity-shader-graph-artist` | Unity shaders |
| `unreal-systems-engineer` | Unreal systems |
| `unreal-world-builder` | Unreal level building |
| `unreal-multiplayer-architect` | Unreal multiplayer |
| `unreal-technical-artist` | Unreal tech art |
| `godot-gameplay-scripter` | Godot GDScript |
| `godot-multiplayer-engineer` | Godot multiplayer |
| `godot-shader-developer` | Godot shaders |
| `roblox-experience-designer` | Roblox experiences |
| `roblox-systems-scripter` | Roblox Luau |
| `roblox-avatar-creator` | Roblox avatars |

### XR / Spatial Computing
| Agent | Use When |
|-------|----------|
| `xr-immersive-developer` | WebXR, immersive apps |
| `xr-interface-architect` | Spatial UI design |
| `xr-cockpit-interaction-specialist` | Cockpit interfaces |
| `visionos-spatial-engineer` | Apple Vision Pro |
| `macos-spatial-metal-engineer` | Metal, macOS spatial |

### Academic / Worldbuilding
| Agent | Use When |
|-------|----------|
| `academic-historian` | Historical accuracy |
| `academic-anthropologist` | Cultural systems |
| `academic-geographer` | Geography, climate |
| `academic-psychologist` | Psychology, behavior |
| `academic-narratologist` | Story structure |

### Specialized
| Agent | Use When |
|-------|----------|
| `agents-orchestrator` | Multi-agent pipeline coordination |
| `specialized-workflow-architect` | Workflow mapping |
| `specialized-chief-of-staff` | Executive operations |
| `specialized-developer-advocate` | DevRel, advocacy |
| `specialized-document-generator` | Document generation |
| `specialized-mcp-builder` | MCP server building |
| `specialized-model-qa` | AI model testing |
| `specialized-salesforce-architect` | Salesforce |
| `specialized-civil-engineer` | Civil engineering |
| `specialized-cultural-intelligence-strategist` | Cultural intelligence |
| `specialized-french-consulting-market` | French market |
| `specialized-korean-business-navigator` | Korean market |
| `blockchain-security-auditor` | Smart contract audits |
| `compliance-auditor` | SOC2, ISO, HIPAA |
| `automation-governance-architect` | Automation governance |
| `blender-addon-engineer` | Blender Python add-ons |
| `lsp-index-engineer` | LSP, semantic indexing |
| `terminal-integration-specialist` | Terminal tooling |
| `zk-steward` | Zero-knowledge proofs |

### Industry-Specific
| Agent | Use When |
|-------|----------|
| `healthcare-customer-service` | Healthcare support |
| `healthcare-marketing-compliance` | Healthcare marketing |
| `legal-document-review` | Legal doc review |
| `legal-client-intake` | Legal intake |
| `legal-billing-time-tracking` | Legal billing |
| `real-estate-buyer-seller` | Real estate |
| `loan-officer-assistant` | Loan processing |
| `hospitality-guest-services` | Hospitality |
| `retail-customer-returns` | Retail returns |
| `hr-onboarding` | HR onboarding |
| `recruitment-specialist` | Recruiting |
| `corporate-training-designer` | Training programs |
| `study-abroad-advisor` | Study abroad |
| `supply-chain-strategist` | Supply chain |
| `government-digital-presales-consultant` | Gov tech sales |
| `language-translator` | Translation |
| `identity-graph-operator` | Identity resolution |
| `agentic-identity-trust` | Agent identity/auth |
| `data-consolidation-agent` | Data consolidation |
| `report-distribution-agent` | Report distribution |

---

## Routing Rules

1. **Single-domain task** → spawn the matching agent directly
2. **Multi-domain task** → spawn `agents-orchestrator` to coordinate
3. **Code task** → always spawn an engineering agent (senior-developer, frontend-developer, backend-architect, etc.)
4. **Review task** → spawn `engineering-code-reviewer` or `testing-reality-checker`. After code changes, spawn `code-simplifier` to refine for clarity and consistency
5. **Unsure which agent** → spawn `agents-orchestrator` and let it decide
6. **Multiple independent subtasks** → spawn multiple agents in parallel
7. **SEO task** → use `/seo` skill for commands, or spawn `seo-*` agents for specific analysis (e.g., `seo-technical`, `seo-content`, `seo-schema`). Full site audits use `/seo audit <url>` which fans out up to 15 SEO agents in parallel
8. **Plan/review/ship workflow** → use gstack skills: `/office-hours` (think) → `/autoplan` (plan) → build → `/review` (review) → `/qa` (test) → `/ship` (release) → `/land-and-deploy` (deploy) → `/canary` (monitor) → `/retro` (reflect)
9. **Security audit** → use `/cso` for OWASP+STRIDE analysis
10. **Web browsing** → always use `/browse <url>`, never raw MCP browser tools
11. **Design task** → use `/design-consultation`, `/design-review`, or `/design-shotgun` for rapid design iteration
12. **Blog/content writing** → use `/blog write <topic>` for full articles, `/blog analyze` for quality audit, `/blog cluster` for topic planning. Spawns `blog-writer`, `blog-researcher`, `blog-reviewer` agents with 5-gate quality contract

## Parallel Execution

When a task has independent parts, spawn agents in parallel:
```
Agent 1: @engineering-frontend-developer → build the UI
Agent 2: @engineering-backend-architect → build the API
Agent 3: @testing-api-tester → write test plan
```

## gstack Skills (Garry Tan's Engineering Team)

gstack provides 54 slash-command skills that form a virtual engineering org. Use these alongside agents for a full Think→Plan→Build→Review→Test→Ship→Deploy→Monitor→Reflect workflow.

| Skill | Role | Use When |
|-------|------|----------|
| `/office-hours` | CEO | YC-style product interrogation, forcing questions |
| `/plan-ceo-review` | CEO | Strategic challenge of a plan |
| `/plan-eng-review` | Eng Manager | Engineering plan review |
| `/plan-design-review` | Designer | Design plan review |
| `/plan-devex-review` | DX Lead | Developer experience review |
| `/plan-tune` | Eng Manager | Tune plan based on feedback |
| `/autoplan` | Pipeline | Auto-review: CEO→design→eng pipeline |
| `/spec` | PM | Write a spec (why→scope→tech→draft→file) |
| `/design-consultation` | Designer | Design consultation |
| `/design-review` | Designer | Design review |
| `/design-shotgun` | Designer | Rapid design iteration |
| `/design-html` | Designer | HTML design mockups |
| `/review` | Staff Engineer | Code review |
| `/qa` | QA Lead | Full QA testing |
| `/qa-only` | QA Lead | QA only (no fix) |
| `/cso` | Security Officer | OWASP+STRIDE security audit |
| `/ship` | Release Engineer | PR→tests→merge release |
| `/land-and-deploy` | Release Engineer | Merge→CI→deploy→verify |
| `/canary` | SRE | Post-deploy monitoring |
| `/retro` | Eng Manager | Weekly engineering retrospective |
| `/browse` | Browser | Real Chromium browser automation |
| `/investigate` | Debugger | Root-cause debugging methodology |
| `/benchmark` | Performance | Performance benchmarks |
| `/devex-review` | DX Lead | Developer experience audit |
| `/learn` | Memory | Session memory & learnings |
| `/freeze` / `/unfreeze` | Guard | File edit restrictions |
| `/guard` | Guard | freeze + careful combined |
| `/careful` | Guard | Destructive command warnings |
| `/skillify` | Meta | Turn code into new skills |
| `/make-pdf` | Docs | Generate PDF reports |
| `/document-generate` | Docs | Documentation generation |
| `/document-release` | Docs | Release notes |
| `/scrape` | Browser | Web scraping |
| `/health` | Ops | System health check |

**Usage:** `/browse https://nattrly.com` for web browsing (always use gstack's browse, never raw mcp tools).

## Logging

All agent activity is automatically logged to `~/.claude/logs/`. Every session is exported to HTML at `~/.claude/logs/chats/`.
