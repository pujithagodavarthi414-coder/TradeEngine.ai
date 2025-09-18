using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class UpsertFolderAndStoreSizeModel
    {
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public long? Size { get; set; }
        public bool IsDeletion { get; set; }
    }
}
