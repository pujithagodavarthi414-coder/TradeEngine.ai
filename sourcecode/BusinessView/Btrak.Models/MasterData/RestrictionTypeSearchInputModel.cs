using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class RestrictionTypeSearchInputModel : SearchCriteriaInputModelBase
    {
        public RestrictionTypeSearchInputModel() : base(InputTypeGuidConstants.RestrictionTypeSearchInputOutputModelGuid)
        {
        }

        public Guid? RestrictionTypeId { get; set; }
    }
}
