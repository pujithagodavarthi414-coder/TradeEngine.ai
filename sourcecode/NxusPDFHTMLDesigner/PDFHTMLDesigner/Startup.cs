using PDFHTMLDesignerServices.Audits;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;
using MongoDB.Bson;
using MongoDB.Bson.Serialization;
using MongoDB.Bson.Serialization.Serializers;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using PDFHTMLDesigner.Helpers;
using System.Threading.Tasks;
using PDFHTMLDesignerServices.DocumentEditor;
using PDFHTMLDesignerRepo.PDFDataSet;
using PDFHTMLDesignerServices.PDFDocumentEditor;
using PDFHTMLDesignerRepo.FileDataSet;
using System.Collections.Generic;
using PDFHTMLDesignerRepo.HTMLDataSet;
using SyncfusionDocument.Controllers;
using Syncfusion.EJ2.SpellChecker;

namespace PDFHTMLDesigner
{
    public class Startup
    {
        internal static List<DictionaryData> spellDictCollection;
        internal static string path;
        internal static string personalDictPath;

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            BsonSerializer.RegisterSerializer(new GuidSerializer(BsonType.String));
            services.AddControllers();

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo
                {
                    Title = "PDF-HTML Designer",
                    Version = "v1"
                });

                c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    In = ParameterLocation.Header,
                    Description = "Please insert JWT with Bearer into field",
                    Name = "Authorization",
                    Type = SecuritySchemeType.ApiKey
                });

                c.AddSecurityRequirement(new OpenApiSecurityRequirement 
                {
                    {
                        new OpenApiSecurityScheme
                        {
                          Reference = new OpenApiReference
                          {
                            Type = ReferenceType.SecurityScheme,
                            Id = "Bearer"
                          }
                        },
                        new string[] { }
                    }
                });
            });

            //Add Cors
            services.AddCors(o => o.AddPolicy("AllowAllOrigins", builder =>
            {
                builder.AllowAnyOrigin()
                       .AllowAnyMethod()
                       .AllowAnyHeader();
            }));

            services.AddTransient<IAuditService, AuditService>();
            services.AddTransient<IPDFMenuDataSetService, PDFMenuDataSetService>();
            services.AddTransient<IPDFMenuDataSetRepository, PDFMenuDataSetRepository>();
            services.AddTransient<IFileDatasetService, FileDatasetService>();
            services.AddTransient<IFileDataSetRepository, FileDataSetRepository>();
            services.AddTransient<IFileConvertionService, FileConvertionService>();
            services.AddTransient<IFileUploadService, FileUploadService>();
            services.AddTransient<IHTMLDataSetService, HTMLDataSetService>();
            services.AddTransient<IHTMLDataSetRepository, HTMLDataSetRepository>();
            services.AddAuthentication("BasicAuthentication").AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
        }


        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            //To allow requests from all origins
            app.UseCors("AllowAllOrigins");
            //Register Syncfusion license
            Syncfusion.Licensing.SyncfusionLicenseProvider.RegisterLicense("Ngo9BigBOggjHTQxAR8/V1NGaF1cXGNCf1FpRmJGdld5fUVHYVZUTXxaS00DNHVRdkdgWXZfc3RWRWJZVU1yXUc=");
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "PDFHTMLDesigner v1"));
            }
            app.UseAuthentication();
            app.UseHttpsRedirection();

            app.UseRouting();
            app.UseCors();
            app.UseAuthorization();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            app.UseSwagger();
            app.UseSwaggerUI(options =>
            {
                options.SwaggerEndpoint("/swagger/v1/swagger.json", "PDFHTMLDesigner API v1");
            });

            app.Run(context =>
            {
                context.Response.Redirect("/swagger");
                return Task.CompletedTask;
            });
        }
    }
}
