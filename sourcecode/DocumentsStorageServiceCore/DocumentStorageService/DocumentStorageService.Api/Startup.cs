using DocumentStorageService.Repositories.AccessRights;
using DocumentStorageService.Repositories.Fake;
using DocumentStorageService.Repositories.FileStore;
using DocumentStorageService.Services.AccessRights;
using DocumentStorageService.Services.FileStore;
using DocumentStorageService.Services.Fake;
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
using DocumentStorageService.Api.Helpers;
using Microsoft.AspNetCore.Http;
using DocumentStorageService.Services.FormDataServices;

namespace DocumentStorageService.Api
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }
        readonly string MyAllowSpecificOrigins = "_myAllowSpecificOrigins";
        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            BsonSerializer.RegisterSerializer(new GuidSerializer(BsonType.String));
            services.AddControllers();
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "Formio", Version = "v1" });
            });
            services.AddCors(options =>
            {
                options.AddPolicy(name: MyAllowSpecificOrigins,
                    builder =>
                    {
                        builder.WithOrigins("*");
                        builder.WithHeaders("*");
                        builder.WithMethods("*");
                    });
            });
            services.AddAuthentication("BasicAuthentication").AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
        services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
        services.AddTransient<StoreRepository, StoreRepository>();
        services.AddTransient<ReferenceTypeRepository, ReferenceTypeRepository>();
        services.AddTransient<UploadFileRepository, UploadFileRepository>();
        services.AddTransient<FileRepository, FileRepository>();
        services.AddTransient<AccessRightsRepository, AccessRightsRepository>();
        services.AddTransient<FakeStoreRepository, FakeStoreRepository>();
        services.AddTransient<FakeFileRepository, FakeFileRepository>();
        services.AddTransient<FakeUploadFileRepository, FakeUploadFileRepository>();
        services.AddTransient<FakeAccessRightsRepository, FakeAccessRightsRepository>();
        services.AddTransient<IStoreService, StoreService>();
        services.AddTransient<IFileStoreService, FileStoreService>();
        services.AddTransient<IFileService, FileService>();
        services.AddTransient<IFileUploadService, FileUploadService>();
        services.AddTransient<IDataSetsService, DataSetsService>();
        services.AddTransient<IAccessService, AccessService>();
        services.AddTransient<IFakeFileService, FakeFileService>();
        services.AddTransient<IFakeStoreService, FakeStoreService>();
        services.AddTransient<IFakeFileUploadService, FakeFileUploadService>();
        services.AddTransient<IFakeAccessService, FakeAccessService>();

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Formio v1"));
            }

            app.UseHttpsRedirection();
            app.UseCors(MyAllowSpecificOrigins);
            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }

}
