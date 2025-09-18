using System;

namespace Btrak.Models.GrERomande
{
    public class GrERomandeSearchOutputModel
    {
        public Guid Id { get; set; }
        public Guid BankId { get; set; }
        public string BankAccountName { get; set; }
        public Guid SiteId { get; set; }
        public string SiteName { get; set; }
        public string Email { get; set; }
        public Guid GrdId { get; set; }
        public string GRDName { get; set; }
        public DateTime Month { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Term { get; set; }
        public DateTime Year { get; set; } 
        public decimal Production { get; set; }
        public decimal Reprise { get; set; }
        public decimal AutoConsumption { get; set; }
        public decimal Facturation { get; set; }
        public string GridInvoice { get; set; }
        public string GridInvoiceName { get; set; }
        public DateTime GridInvoiceDate { get; set; }
        public bool IsGre { get; set; }
        public decimal HauteTariff { get; set; }
        public decimal BasTariff { get; set; }
        public decimal? TariffTotal { get; set; }
        public decimal Distribution { get; set; }
        public decimal GreFacturation { get; set; }
        public decimal? GreTotal { get; set; }
        public decimal AdministrationRomandeE { get; set; }
        public bool ConfirmDetailsfromGrid { get; set; }
        public decimal AutoConsumptionSum { get; set; }
        public decimal FacturationSum { get; set; }
        public decimal SubTotal { get; set; }
        public decimal TVA { get; set; }
        public decimal TVAForSubTotal { get; set; }
        public decimal Total { get; set; }
        public decimal AutoCTariff { get; set; }
        public string InvoiceUrl { get; set; }
        public bool GenerateInvoice { get; set; }
        public decimal SolarLogValueKwh { get; set; }
        public decimal PlannedSystem { get; set; }
        public decimal PlannedAutoC { get; set; }
        public string MessageType { get; set; }
        public Guid CompanyId { get; set; }
        public decimal? PRATotal { get; set; }
        public string PRAFields { get; set; }
        public string DFFields { get; set; }
        public decimal? OutStandingAmount { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedBy { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
