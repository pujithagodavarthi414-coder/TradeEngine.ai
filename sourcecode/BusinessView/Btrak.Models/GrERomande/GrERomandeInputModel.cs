using BTrak.Common;
using System;

namespace Btrak.Models.GrERomande
{
    public class GrERomandeInputModel : InputModelBase
    {
        public GrERomandeInputModel() : base(InputTypeGuidConstants.GrERomandeInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public Guid SiteId { get; set; }
        public Guid GrdId { get; set; }
        public Guid BankId { get; set; }
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
        public decimal? HauteTariff { get; set; }
        public decimal? BasTariff { get; set; }
        public decimal? TariffTotal { get; set; }
        public decimal? Distribution { get; set; }
        public decimal? GreFacturation { get; set; }
        public decimal? GreTotal { get; set; }
        public decimal? AdministrationRomandeE { get; set; }
        public bool ConfirmDetailsfromGrid { get; set; }
        public decimal AutoConsumptionSum { get; set; }
        public decimal FacturationSum { get; set; }
        public decimal SubTotal { get; set; }
        public decimal TVA { get; set; }
        public decimal? PRATotal { get; set; }
        public string PRAFields { get; set; }
        public string DFFields { get; set; }
        public decimal TVAForSubTotal { get; set; }
        public decimal Total { get; set; }
        public decimal AutoCTariff { get; set; }
        public bool GenerateInvoice { get; set; }
        public string InvoiceUrl { get; set; }
        public bool? IsArchived { get; set; }
        public string MessageType { get; set; }
        public bool? IsInvoiceBit { get; set; }
        public Guid? HistoryId { get; set; }
        public decimal? OutStandingAmount { get; set; }
    }
}
