using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.DocumentManagement
{
    public class SearchFoldersAndFilesInputModel : SearchCriteriaInputModelBase
    {
        public SearchFoldersAndFilesInputModel() : base(InputTypeGuidConstants.SearchFoldersAndFilesInputCommandTypeGuid)
        {
        }

        public Guid? StoreId { get; set; }
        public Guid? ParentFolderId { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StoreId = " + StoreId);
            stringBuilder.Append("ParentFolderId = " + ParentFolderId);
            stringBuilder.Append("SearchText = " + SearchText);
            stringBuilder.Append("IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
