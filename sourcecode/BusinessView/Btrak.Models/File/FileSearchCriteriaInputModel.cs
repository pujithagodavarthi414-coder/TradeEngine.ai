using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.File
{
    public class FileSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public FileSearchCriteriaInputModel() : base(InputTypeGuidConstants.FileSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? FileId { get; set; }
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public Guid? UserStoryId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FileId = " + FileId);
            stringBuilder.Append("FolderId = " + FolderId);
            stringBuilder.Append("StoreId = " + StoreId);
            stringBuilder.Append("ReferenceId = " + ReferenceId);
            stringBuilder.Append("ReferenceTypeId = " + ReferenceTypeId);
            stringBuilder.Append("IsArchived = " + IsArchived);
            stringBuilder.Append("SearchText = " + SearchText);
            stringBuilder.Append("SortBy = " + SortBy);
            stringBuilder.Append("SortDirection = " + SortDirection);
            stringBuilder.Append("PageSize = " + PageSize);
            stringBuilder.Append("PageNumber = " + PageNumber);
            return stringBuilder.ToString();
        }
    }
}
