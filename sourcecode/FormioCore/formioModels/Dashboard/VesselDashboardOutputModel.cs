using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using static System.Formats.Asn1.AsnWriter;

namespace formioModels.Dashboard
{
    public class VesselDashboardOutputModel
    {
        public string SourceCommodity { get; set; }
        public string ProductGroup { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal TotalContractQuantity { get; set; }
        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal TotalSotQuantity { get; set; }
        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal SotDifference { get; set; }
        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal PurchaseQuantity { get; set; }
        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal Utilization { get; set; }
        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal AddBack { get; set; }
        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal PandLINR { get; set; }
        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal PandLUSD { get; set; }
        public decimal PandLRealisedUSD { get; set; }
        public decimal PandLUnRealisedUSD { get; set; }
        public decimal UtilizedQuantity { get; set; }
        public List<ProductionDataModel> Productions { get; set; }
        public List<ProfitAndLossModel> ProfitAndLosses { get; set; }
        public string CompanyName { get; set; }
    }

    public class ProductionDataModel
    {
        public string ProducedCommodity { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal ProducedQuantity { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal SoldQuantity { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal RealisedValue { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal AvailableBalance { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal MTMRate { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal UnRealisedValue { get; set; }

        public int Order
        {
            get; set;
        }
    }
    public class ProfitAndLossModel
    {
        // Properties for the given fields
        public string Cost { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal RealisedCostYTD { get; set; }
        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal MtmRate { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal UnRealisedCost { get; set; }
        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal TotalPAndL { get; set; }
        public bool? IsBold { get; set; }
        public bool? IsBackground { get; set; }

        // Other properties can be added here, if needed.
    }

    public class salesList1
    {
        public string Commodity { get; set; }
        [BsonRepresentation(MongoDB.Bson.BsonType.Decimal128, AllowTruncation = true)]
       // [BsonSerializer(typeof(CustomDecimal128Serializer))]
        public decimal RealisedValue { get; set; }
        [BsonRepresentation(MongoDB.Bson.BsonType.Decimal128, AllowTruncation = true)]
        public decimal SoldQty { get; set; }
        [BsonRepresentation(MongoDB.Bson.BsonType.Decimal128, AllowTruncation = true)]
        public decimal ConsumedQty { get; set; }
    }
    public class salesList2
    {
        public string commodity { get; set; }
        public decimal quantity { get; set; }
    }
    public class salesList3
    {
        public string Commodity { get; set; }
        public string CompanyName { get; set; }
        public decimal MTMRate { get; set; }
        public decimal USDToInr { get; set; }
    }

    public class PositionData
    {
        public string PositionName { get; set; }
        public string Commodity { get; set; }
        public string CommodityKey { get; set; }
        public string CompanyName { get; set; }
        public string Position { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal OpeningBalance { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDgross { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDgross1 { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDgross2 { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDgross3 { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDgross4 { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDgross5 { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDgross6 { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDgross7 { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal TotalGross { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal NetClosing { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal NetOpening { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal DayChange { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal DayChangeMtm { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal DailyMTM { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal DayPAndL { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal MTDPAndL { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDRealisedPAndL { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDUnRealisedPAndL { get; set; }

        [DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
        public decimal YTDTotalPAndL { get; set; }

        public List<PositionData> Children { get; set; }
        public bool IsGroupBy { get; set; }
        public bool IsBold { get; set; }
        public double Id { get; set; }
        public decimal Order { get; set; }
    }
    public class MonthYearOrder
    {
        public int Month { get; set; }
        public int Year { get; set; }
        public int Order { get; set; }
    }
    public class PositionList1
    {
        public string CompanyName { get; set; }
        public string Commodity { get; set; }
        public decimal OpeningBalance { get; set; }
        public decimal SGOpeningBalance { get; set; }
    }
    public class PositionList2
    {
        public string CompanyName { get; set; }
        public string Commodity { get; set; }
        public decimal TotalQty { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
    }
    public class PositionList3
    {
        public string CompanyName { get; set; }
        public string Commodity { get; set; }
        public string ParentCommodity { get; set; }
        public decimal TotalQty { get; set; }
        public decimal TodayTotalQty { get; set; }
        public decimal MonthTotalQty { get; set; }
        public decimal RealisedValue { get; set; }
        public decimal TodayRealisedValue { get; set; }
        public decimal MonthRealisedValue { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
    }
    public class PositionList6
    {
        public string CompanyName { get; set; }
        public string ProductGroup { get; set; }
        public decimal Cancellation { get; set; }
        public decimal TodayCancellation { get; set; }
    }
    public class PositionList7
    {
        public string Commodity { get; set; }
        public string CompanyName { get; set; }
        public decimal? MTMRate { get; set; }
        public decimal? DerivedUsdRate { get; set; }
        public decimal? CnfRateUsd { get; set; }
        public decimal? DerivedMdexRateUsd { get; set; }
        public decimal? USDToInr { get; set; }
        public decimal? SpotRateUsdMyr { get; set; }
        public decimal? OldMTMRate { get; set; }
        public decimal? OldDerivedUsdRate { get; set; }
        public decimal? OldCnfRateUsd { get; set; }
        public decimal? OldDerivedMdexRateUsd { get; set; }
        public decimal? OldUSDToInr { get; set; }
        public decimal? OldSpotRateUsdMyr { get; set; }
    }
    public class PositionList8
    {
        public string CompanyName { get; set; }
        public string SourceCommodity { get; set; }
        public decimal UnRealizedValue { get; set; }
        public decimal UnRealizedQty { get; set; }
        public decimal RealizedQty { get; set; }
    }
    public class PositionList9
    {
        public string CompanyName { get; set; }
        public string SourceCommodity { get; set; }
        public decimal TotalQty { get; set; }
        public decimal Realized { get; set; }
        public decimal UnRealized { get; set; }
    }
    public class PositionList10
    {
        public string CompanyName { get; set; }
        public string Commodity { get; set; }
        public decimal UnRealizedValue { get; set; }
        public decimal UnRealizedQty { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
    }
    public class PositionList11
    {
        public string Commodity { get; set; }
        public decimal DerivedMdexRateUsd { get; set; }
        public decimal CnfRateUsd { get; set; }
        public decimal SpotRateUsdMyr { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
    }
    public class VesselLoopModel
    {
        public string CompanyName { get; set; }
        public string Commodity { get; set; }
        public string UniqueIdImportLocal { get; set; }
        public string Type { get; set; }
    }

    public class YTDPandLHistory 
    {
        public Guid? Id { get; set; }
        public string CompanyName { get; set; }
        public double CommodityId { get; set; }
        public string Name { get; set; }
        public string DisplayName{ get; set; }
        public decimal YTDRealisedPAndL { get; set; }
        public decimal YTDUnRealisedPAndL { get; set; }
        public decimal YTDTotalPAndL { get; set; }
        public decimal NetClosing { get; set; }
        public DateTime Date { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public bool? IsArchived { get; set; }
    }
}