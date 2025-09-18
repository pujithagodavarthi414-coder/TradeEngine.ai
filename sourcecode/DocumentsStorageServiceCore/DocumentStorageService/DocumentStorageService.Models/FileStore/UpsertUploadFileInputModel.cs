using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
   public  class UpsertUploadFileInputModel
    {
        public Guid? UploadFileId { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public long? FileSize { get; set; }
        public Guid? ReferenceId { get; set; }
        public string ReferenceTypeName { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public bool? IsArchived { get; set; }
        public string FileExtension { get; set; }
    }
}
