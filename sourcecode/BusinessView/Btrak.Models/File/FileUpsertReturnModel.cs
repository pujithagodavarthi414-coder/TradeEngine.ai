﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.File
{
    public class FileUpsertReturnModel
    {
        public Guid? FileId { get; set; }
        public Guid? FolderId { get; set; }
        public long? FileSize { get; set; }
        public Guid? StoreId { get; set; }
        public byte[] TimeStamp { get; set; }
    } 
}
