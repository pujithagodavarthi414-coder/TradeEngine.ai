using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
   public class FileSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public Guid? FileId { get; set; }
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public Guid? UserStoryId { get; set; }
        public string ReferenceTypeName { get; set; }
        public string FileName { get; set; }
    }
}
