using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class DeleteFileReturnModel
    {
        public Guid? FileId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public long? FileSize { get; set; }
    }
}
