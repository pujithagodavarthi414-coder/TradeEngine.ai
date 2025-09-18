using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
   public  class StoreUpsertInputModel
    {
        public Guid? StoreId { get; set; }
        public string StoreName { get; set; }
        public bool? IsCompany { get; set; }
        public bool? IsDefault { get; set; }
        public long? StoreSize { get; set; }

    }
}
