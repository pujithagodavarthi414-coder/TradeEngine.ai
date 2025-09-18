using BTrak.Common;
using System;

namespace Btrak.Models.GRD
{
    public class GRDInputModel : InputModelBase
    {
        public GRDInputModel() : base(InputTypeGuidConstants.GRDInputCommandTypeGuid)
        {

        }

        public Guid? Id { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string Name { get; set; }
        public decimal RepriseTariff { get; set; }
        public decimal AutoCTariff { get; set; }
        public bool? IsArchived { get; set; }
    }
}
