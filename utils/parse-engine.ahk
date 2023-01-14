ParseEngine(engine:="google")
{
    Switch engine
    {
        case "google":
            Return "https://www.google.com/search?hl=en&q="
        case "brave":
            Return "https://search.brave.com/search?q="
        case "ecosia":
            Return "https://www.ecosia.org/search?tt=mzl&q="
        case "duckduckgo":
            Return "https://duckduckgo.com/?q="
        case "duck":
            Return "https://duckduckgo.com/?q="
    }
}