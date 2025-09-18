using BTrak.Common;
using System;

namespace Btrak.Models.Goals
{
    public class GoalsToArchiveSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GoalsToArchiveSearchCriteriaInputModel() : base(InputTypeGuidConstants.GoalsToArchiveSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? EntityId { get; set; }
        public Guid? ProjectId { get; set; }
    }
}
