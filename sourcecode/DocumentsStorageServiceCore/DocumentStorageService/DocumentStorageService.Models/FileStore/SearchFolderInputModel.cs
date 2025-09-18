using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
   public  class SearchFolderInputModel
    {
        public Guid? FolderId { get; set; }
        public Guid? ParentFolderId { get; set; }
        public Guid? StoreId { get; set; }
        public string FolderName { get; set; }
        public Guid? FolderReferenceId { get; set; }
        public Guid? FolderReferenceTypeId { get; set; }
        public bool? IsFromSprints { get; set; }
        public bool? IsTreeView { get; set; }
        public Guid? UserStoryId { get; set; }
        public int PageSize { get; set; } = 1000;
        public int PageNumber { get; set; } = 1;
        public string SearchText { get; set; }
        public string ParentFolderName { get; set; }
        public bool? IsArchived { get; set; }
        public int Skip => (PageNumber == 1 || PageNumber == 0) ? 0 : PageSize * (PageNumber - 1);
        public string SortBy { get; set; }
        public bool SortDirectionAsc { get; set; }
        public string SortDirection => SortDirectionAsc ? "ASC" : "DESC";

    }
}
