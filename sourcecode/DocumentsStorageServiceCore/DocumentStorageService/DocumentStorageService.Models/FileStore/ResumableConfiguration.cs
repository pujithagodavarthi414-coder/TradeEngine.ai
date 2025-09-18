using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class ResumableConfiguration
    {
		public int Chunks { get; set; }

		/// <summary>
		/// Gets or sets unique identifier for current upload.
		/// </summary>
		public string Identifier { get; set; }

		/// <summary>
		/// Gets or sets file name.
		/// </summary>
		public string FileName { get; set; }

		/// <summary>
		/// Gets or sets file name.
		/// </summary>
		public int ModuleTypeId { get; set; }

		public static ResumableConfiguration Create(string identifier, string filename, int chunks, int moduleTypeId)
		{
			return new ResumableConfiguration { Identifier = identifier, FileName = filename, Chunks = chunks, ModuleTypeId = moduleTypeId };
		}
	}
}
