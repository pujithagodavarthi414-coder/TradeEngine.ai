using BTrak.Common;
using System;

namespace Btrak.Models.TVA
{
    public class TVAInputModel : InputModelBase
    {
        public TVAInputModel() : base(InputTypeGuidConstants.TVAInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public decimal TVA { get; set; }
        public bool? IsArchived { get; set; }

    }
}
