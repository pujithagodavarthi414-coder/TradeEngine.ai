using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class FilePostInputModel
    {
        public byte[] MemoryStream { get; set; }
        public string FileName { get; set; }
        public string ContentType { get; set; }
        public int ChunkId { get; set; }
        public Guid? LoggedInUserId { get; set; }

        public Guid FileId { get; set; }
    }
}
