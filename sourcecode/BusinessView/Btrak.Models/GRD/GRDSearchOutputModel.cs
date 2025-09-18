using System;

namespace Btrak.Models.GRD
{
    public class GRDSearchOutputModel
    {
        public Guid Id { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string Name { get; set; }
        public decimal RepriseTariff { get; set; }
        public decimal AutoCTariff { get; set; }
        public decimal? TVAValue { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
