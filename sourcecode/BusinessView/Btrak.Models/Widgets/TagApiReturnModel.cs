using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Widgets
{
   public  class TagApiReturnModel
    {
        public Guid? TagId { get; set; }
        public Guid? ParentTagId { get; set; }
        public string Tags { get; set; }
    }
}
