using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Goals
{
   public class GoalFilterSerachCriterisInputModel : SearchCriteriaInputModelBase
    {
        public GoalFilterSerachCriterisInputModel() : base(InputTypeGuidConstants.GoalSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? GoalFilterId { get; set; }
        public Guid? GoalFilterDetailsId { get; set; }
    }
}
