using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models
{
   public  class ParamsInputModel
    {
        public string Type { get; set; }
        public string Key { get; set; }
        public dynamic Value { get; set; }
    }
}
