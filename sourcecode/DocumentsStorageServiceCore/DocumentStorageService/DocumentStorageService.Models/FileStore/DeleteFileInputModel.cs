using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class DeleteFileInputModel
    {
        public Guid? FileId { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
