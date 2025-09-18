using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class ReferenceTypeSearchInputModel : SearchCriteriaInputModelBase
    {
        public Guid? ReferenceTypeId { get; set; }
        public string ReferenceTypeName { get; set; }
    }
}
