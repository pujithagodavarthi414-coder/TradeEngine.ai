using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class StoreInputModel
    {
        public Guid? StoreId { get; set; }
        public string StoreName { get; set; }
        public long? StoreSize { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsCompany { get; set; }
    }
}
