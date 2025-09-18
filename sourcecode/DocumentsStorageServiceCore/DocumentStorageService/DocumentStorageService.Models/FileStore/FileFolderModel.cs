using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class FileFolderModel
    {
        public Guid? Id { get; set; }
        public string Name { get; set; }
        public Guid? ParentFolderId { get; set; }
        public long? Size { get; set; }
        public string FilePath { get; set; }
        public bool? IsFolder { get; set; }
        public Guid? StoreId { get; set; }
        public string ReviewedByUserName { get; set; }
        public Guid? ReviewedByUserId { get; set; }
        public bool? IsToBeReviewed { get; set; }
        public int? Count { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? ReviewedDateTime { get; set; }
        public string Extension { get; set; }
    }
}
