using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Site
{
    public class SiteUpsertModel : InputModelBase
    {
        public SiteUpsertModel() : base(InputTypeGuidConstants.UpsertSiteInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string Addressee { get; set; }
        public bool IsArchived { get; set; }
        public decimal? AutoCTariff { get; set; }
        public string RoofRentalAddress { get; set; }
        public DateTime Date { get; set; }
        public string ParcellNo { get; set; }
        public decimal? M2 { get; set; }
        public decimal? Chf { get; set; }
        public int Term { get; set; }
        public string Muncipallity { get; set; }
        public string Canton { get; set; }
        public int ProductionFirstYear { get; set; }
        public DateTime? StartingYear { get; set; }
        public decimal AutoCExpected { get; set; }
        public decimal AnnualReduction { get; set; }
        public decimal RepriceExpected { get; set; }
    }
}
