using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.AccessRights
{
   public class AccessRightsReturnModel
    {
        public Guid? Id { get; set; }
        public string FileName { get; set; }
        public List<AccessModel> AccessRights { get; set; }
        public string FilePath { get; set; }
    }
}
