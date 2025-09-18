using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.File
{
    public class SearchFolderInputModel : SearchCriteriaInputModelBase
    {
        public SearchFolderInputModel() : base(InputTypeGuidConstants.SearchFolderInputCommandTypeGuid)
        {
        }

        public Guid? FolderId { get; set; }
        public Guid? ParentFolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? FolderReferenceId { get; set; }
        public Guid? FolderReferenceTypeId { get; set; }
        public bool? IsFromSprints { get; set; }
        public bool? IsTreeView { get; set; }
        public Guid? UserStoryId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FolderId = " + FolderId);
            stringBuilder.Append(", ParentFolderId= " + ParentFolderId);
            stringBuilder.Append(", StoreId= " + StoreId);
            stringBuilder.Append(", FolderReferenceId= " + FolderReferenceId);
            stringBuilder.Append(", FolderReferenceTypeId= " + FolderReferenceTypeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", SortBy = " + SortBy);
            stringBuilder.Append(", SortDirection = " + SortDirection);
            stringBuilder.Append(", PageSize = " + PageSize);
            stringBuilder.Append(", PageNumber = " + PageNumber);
            return stringBuilder.ToString();

        }

    }
}