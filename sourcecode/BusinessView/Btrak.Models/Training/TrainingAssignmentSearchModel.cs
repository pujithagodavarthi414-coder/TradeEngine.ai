using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Training
{
    public class TrainingAssignmentSearchModel : SearchCriteriaInputModelBase
    {
        public TrainingAssignmentSearchModel() : base(InputTypeGuidConstants.SearchTrainingAssignmentsSearchInputCommandTypeGuid)
        {
        }

        public List<Guid> UserIds { get; set; }
        public List<Guid> TrainingCourseIds { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserIds = " + (UserIds != null ? string.Join(",", UserIds) : string.Empty));
            stringBuilder.Append(" TrainingCourseIds = " + (TrainingCourseIds != null ? string.Join(",", TrainingCourseIds) : string.Empty));
            stringBuilder.Append(", SortBy = " + SortBy);
            stringBuilder.Append(", SortDirectionAsc = " + SortDirectionAsc);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", PageSize = " + PageSize);
            stringBuilder.Append(", PageNumber = " + PageNumber);
            return stringBuilder.ToString();
        }
    }
}
