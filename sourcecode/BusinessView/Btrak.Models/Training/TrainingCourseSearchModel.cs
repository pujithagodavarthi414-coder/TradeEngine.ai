using BTrak.Common;
using System.Text;

namespace Btrak.Models.Training
{
    public class TrainingCourseSearchModel : SearchCriteriaInputModelBase
    {
        public TrainingCourseSearchModel(): base(InputTypeGuidConstants.SearchTrainingCoursesInputCommandTypeGuid)
        {
        }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("IsArchived = " + IsArchived);
            stringBuilder.Append(", SortBy = " + SortBy);
            stringBuilder.Append(", SortDirectionAsc = " + SortDirectionAsc);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", PageSize = " + PageSize);
            stringBuilder.Append(", PageNumber = " + PageNumber);
            return stringBuilder.ToString();
        }
    }
}
