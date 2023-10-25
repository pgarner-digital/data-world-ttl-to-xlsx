package gov.fl.digital.ddw2infa;

public enum AgencyAndTtlFileName implements AgencyName {
    AHCA(true),
    APD(true),
    BOG(true),
    CHS(false),
    CITRUS(false),
    DBPR(true),
    DBS(true),
    DCF(true),
    DEM(false),
    DEO(true),
    DEP(false),
    DFS(false),
    DHSMV(true),
    DJJ(false),
    DLA(false),
    DMA(false),
    DMS(true),
    DOACS(false),
    DOAH(false),
    DOE(true),
    DOEA(true),
    DOH(true),
    DOL(true),
    DOR(true),
    DOS(false),
    DOT(true),
    DVA(false),
    EOG(false),
    FCHR(false),
    FCOR(false),
    FDC(false),
    FDLE(false),
    FSDB(false),
    FWC(false),
    GAL(false),
    HOUSE(false),
    JAC(false),
    NFWMD(false),
    OEL(false),
    OLITS(false),
    PERC(false),
    PSC(false),
    SCS(false),
    SENATE(false),
    SRWMD(false),
    VR(true)
    ;
    private final boolean isFullGraph;

    AgencyAndTtlFileName(boolean isFullGraph) { this.isFullGraph = isFullGraph; }

    public String getFileName() {
        StringBuilder sb = new StringBuilder("fl-").append(name().toLowerCase());
        if (isFullGraph) { sb.append("-full-graph"); }
        sb.append(".ttl");
        return sb.toString();
    }

    @Override
    public String getOrgId() { return name(); }
}
