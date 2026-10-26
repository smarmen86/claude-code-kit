// categories.mjs — classify an agent slug into one of a fixed set of categories.
// Filename prefixes in this repo are inconsistent (many one-off singletons), so we
// classify with: explicit slug overrides → prefix rules → keyword fallback → default.

export const CATEGORIES = [
  "Engineering",
  "Testing & QA",
  "Design & UX",
  "Marketing",
  "China Marketing",
  "Paid Media",
  "SEO",
  "Blog",
  "Sales",
  "Finance",
  "Product",
  "Project Management",
  "Healthcare",
  "Legal",
  "Game Dev",
  "XR & Spatial",
  "Data & AI",
  "Education",
  "E-commerce",
  "Creative",
  "Industry",
  "Academic",
  "Support & Ops",
  "Specialized",
];

// Explicit overrides for slugs the prefix rules would misclassify.
const SLUG_OVERRIDES = {
  // China Marketing (carved out of the marketing- prefix)
  "marketing-douyin-strategist": "China Marketing",
  "marketing-xiaohongshu-specialist": "China Marketing",
  "marketing-wechat-official-account": "China Marketing",
  "marketing-bilibili-content-strategist": "China Marketing",
  "marketing-baidu-seo-specialist": "China Marketing",
  "marketing-weibo-strategist": "China Marketing",
  "marketing-zhihu-strategist": "China Marketing",
  "marketing-kuaishou-strategist": "China Marketing",
  "marketing-china-ecommerce-operator": "China Marketing",
  "marketing-china-market-localization-strategist": "China Marketing",
  "marketing-private-domain-operator": "China Marketing",
  "marketing-livestream-commerce-coach": "China Marketing",
  "marketing-cross-border-ecommerce": "China Marketing",
  "marketing-short-video-editing-coach": "China Marketing",
  "engineering-wechat-mini-program-developer": "China Marketing",
  "engineering-feishu-integration-developer": "China Marketing",
  "government-digital-presales-consultant": "China Marketing",
  "healthcare-marketing-compliance": "China Marketing",
  "recruitment-specialist": "China Marketing",
  "supply-chain-strategist": "China Marketing",

  // Data & AI
  "sql-query-agent": "Data & AI",
  "rag-pipeline-agent": "Data & AI",
  "ml-pipeline-agent": "Data & AI",
  "model-evaluation-agent": "Data & AI",
  "prompt-engineering-agent": "Data & AI",
  "web-scraping-agent": "Data & AI",
  "knowledge-base-agent": "Data & AI",
  "data-cleaning-agent": "Data & AI",
  "data-extraction-agent": "Data & AI",
  "data-visualization-agent": "Data & AI",
  "data-consolidation-agent": "Data & AI",
  "zk-steward": "Data & AI",

  // Education
  "virtual-tutor-agent": "Education",
  "study-partner-agent": "Education",
  "study-abroad-advisor": "Education",
  "curriculum-designer-agent": "Education",
  "essay-grading-agent": "Education",
  "research-scholar-agent": "Education",
  "corporate-training-designer": "Education",

  // E-commerce
  "product-recommendation-agent": "E-commerce",
  "product-listing-agent": "E-commerce",
  "pricing-strategy-agent": "E-commerce",
  "inventory-optimization-agent": "E-commerce",
  "personal-shopper-agent": "E-commerce",

  // Creative
  "book-writing-agent": "Creative",
  "book-recommendation-agent": "Creative",
  "screenplay-writer-agent": "Creative",
  "recipe-creator-agent": "Creative",
  "landing-page-agent": "Creative",
  "social-media-post-agent": "Creative",
  "movie-recommendation-agent": "Creative",
  "marketing-book-co-author": "Creative",

  // Industry
  "real-estate-buyer-seller": "Industry",
  "smart-farming-agent": "Industry",
  "energy-forecasting-agent": "Industry",
  "manufacturing-monitor-agent": "Industry",
  "logistics-optimization-agent": "Industry",
  "loan-officer-assistant": "Industry",
  "property-pricing-agent": "Industry",
  "threat-detection-agent": "Industry",

  // Finance (market analysis)
  "trading-strategy-agent": "Finance",
  "stock-analysis-agent": "Finance",
  "crypto-analysis-agent": "Finance",
  "financial-report-agent": "Finance",
  "budget-planning-agent": "Finance",
  "invoice-processing-agent": "Finance",
  "accounts-payable-agent": "Finance",

  // Healthcare
  "health-insights-agent": "Healthcare",
  "health-insurance-claims-agent": "Healthcare",
  "healthcare-customer-service": "Healthcare",
  "medical-research-agent": "Healthcare",
  "patient-intake-agent": "Healthcare",
  "clinical-protocol-agent": "Healthcare",

  // Support & Ops
  "customer-service": "Support & Ops",
  "customer-feedback-agent": "Support & Ops",
  "hospitality-guest-services": "Support & Ops",
  "retail-customer-returns": "Support & Ops",
  "hr-onboarding": "Support & Ops",
  "meeting-assistant-agent": "Support & Ops",
  "personal-productivity-agent": "Support & Ops",
  "event-planner-agent": "Support & Ops",
  "trip-planner-agent": "Support & Ops",
  "lead-scoring-agent": "Sales",
  "email-campaign-agent": "Marketing",
  "email-auto-responder-agent": "Support & Ops",
  "marketing-strategy-agent": "Marketing",
  "competitive-intelligence-agent": "Marketing",
  "content-repurposer-agent": "Marketing",
  "media-trend-agent": "Marketing",

  // Engineering (blockchain/security that prefix rules would scatter)
  "blockchain-security-auditor": "Engineering",
  "job-posting-agent": "Support & Ops",

  // Specialized
  "agents-orchestrator": "Specialized",
  "agent-builder-agent": "Specialized",
  "agentic-identity-trust": "Specialized",
  "identity-graph-operator": "Specialized",
  "automation-governance-architect": "Specialized",
  "api-design-agent": "Engineering",
  "config-audit-agent": "Engineering",
  "dependency-audit-agent": "Engineering",
  "changelog-agent": "Engineering",
  "migration-agent": "Engineering",
  "readme-generator-agent": "Engineering",
  "markdown-validator-agent": "Engineering",
  "code-debugging-agent": "Engineering",
  "code-generation-agent": "Engineering",
  "code-simplifier": "Engineering",
  "lsp-index-engineer": "Engineering",
  "macos-spatial-metal-engineer": "XR & Spatial",
  "visionos-spatial-engineer": "XR & Spatial",
  "terminal-integration-specialist": "Engineering",
  "technical-artist": "Game Dev",
  "narrative-designer": "Game Dev",
  "level-designer": "Game Dev",
  "game-designer": "Game Dev",
  "game-audio-engineer": "Game Dev",
};

// Clean prefixes → category. Checked after slug overrides.
const PREFIX_RULES = [
  ["engineering-", "Engineering"],
  ["testing-", "Testing & QA"],
  ["design-", "Design & UX"],
  ["seo-", "SEO"],
  ["blog-", "Blog"],
  ["sales-", "Sales"],
  ["paid-media-", "Paid Media"],
  ["finance-", "Finance"],
  ["product-", "Product"],
  ["project-management-", "Project Management"],
  ["project-manager-", "Project Management"],
  ["legal-", "Legal"],
  ["healthcare-", "Healthcare"],
  ["academic-", "Academic"],
  ["marketing-", "Marketing"],
  ["unity-", "Game Dev"],
  ["unreal-", "Game Dev"],
  ["godot-", "Game Dev"],
  ["roblox-", "Game Dev"],
  ["xr-", "XR & Spatial"],
  ["support-", "Support & Ops"],
  ["specialized-", "Specialized"],
];

// Keyword fallback → category (checked against slug + name + description).
const KEYWORD_RULES = [
  [/\b(unity|unreal|godot|roblox|game|level design|narrative|shader)\b/i, "Game Dev"],
  [/\b(seo|serp|backlink|schema markup)\b/i, "SEO"],
  [/\b(sales|pipeline|deal|prospect|outbound)\b/i, "Sales"],
  [/\b(finance|accounting|tax|invoice|budget|investment|trading|stock|crypto)\b/i, "Finance"],
  [/\b(legal|contract|litigation|compliance counsel)\b/i, "Legal"],
  [/\b(clinic|medical|patient|health|insurance claim)\b/i, "Healthcare"],
  [/\b(marketing|content|social media|growth|ad copy|brand)\b/i, "Marketing"],
  [/\b(data|sql|etl|ml|machine learning|rag|embedding|model)\b/i, "Data & AI"],
  [/\b(design|ux|ui|accessibility|visual)\b/i, "Design & UX"],
  [/\b(test|qa|benchmark|evidence)\b/i, "Testing & QA"],
];

export function classify(agent) {
  const slug = agent.slug;
  if (SLUG_OVERRIDES[slug]) return SLUG_OVERRIDES[slug];
  for (const [prefix, cat] of PREFIX_RULES) {
    if (slug.startsWith(prefix)) return cat;
  }
  const hay = `${slug} ${agent.name} ${agent.description}`;
  for (const [re, cat] of KEYWORD_RULES) {
    if (re.test(hay)) return cat;
  }
  return "Specialized";
}
