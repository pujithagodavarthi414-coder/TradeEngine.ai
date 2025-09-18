using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
   public  class UpsertFolderInputModel
    {
        public Guid? FolderId { get; set; }
        public string FolderName { get; set; }
        public string Description { get; set; }
        public Guid? ParentFolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? FolderReferenceId { get; set; }
        public Guid? FolderReferenceTypeId { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? DefaultFolderId { get; set; }
        public long? Size { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public List<UpsertFolderInputModel> ChildFolders { get; set; }
        public List<string> ParentFolderNames { get; set; }
    }
}
