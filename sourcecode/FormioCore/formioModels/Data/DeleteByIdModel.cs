using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Newtonsoft.Json;

namespace Models.GenericSearch
{
    public class DeleteByIdRequest
    {
        [Required]
        public Guid? ID { get; set; }
    }

    public class DeleteByIdResponse
    {
        public bool IsSuccess { get; set; }
        public string Message { get; set; }
    }
}
