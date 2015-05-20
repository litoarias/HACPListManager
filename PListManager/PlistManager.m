//
//  PlistManager.m
//  SantanderRio
//
//  Created by Invitado on 22/1/15.
//  Copyright (c) 2015 Indra. All rights reserved.
//

#import "PlistManager.h"

@implementation PlistManager


+ (BOOL) createFullFilePath:(NSString *)fileName
{
    
    BOOL success;
    
    NSError *error;
    
    //FileManager - objeto que permite un acceso facil a los archivos del sistema
    NSFileManager *FileManager = [NSFileManager defaultManager];
    
    //Obtiene la ruta del directorio documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Obtiene la primera ruta en el array
    NSString *documentsDirectory = [[NSString alloc]initWithFormat:@"%@/", [paths objectAtIndex:0]];
    
    //Crea la ruta completa para la BBDD
    NSString *databasePath = [documentsDirectory stringByAppendingString:fileName];
    
    //chequea que exista el fichero (o no)
    success = [FileManager fileExistsAtPath:databasePath];
    //NSLog(@"rutaaaa:%@",databasePath);
    
    // si existe se sale
    if(success) {
        NSLog(@"ya existe el archivo (vacio)");
        return YES;
    }else{
        NSLog(@"No existe");
    }
    
    // la BBDD no existe, asi que la copiamos en el directorio documents (creamos la ruta)
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    // copiamos la BBDD
    success = [FileManager copyItemAtPath:dbPath toPath:databasePath error: &error];
    
    ////NSLog(@"se copia el archivo");
    if(!success)
    {
        NSAssert1(0, @"Failed to copy BBDD. Error: %@", [error localizedDescription]);
    }
    
    return NO;
    
    
    
}

+ (void) insertObjectWithData:(NSDictionary *)data fileName:(NSString *) fileName {
    
    if(data[kImage]){
        // Get name unique for image
        NSString *imageName = [PlistManager createImageName];
        // Create mutable dictionary for add keys
        NSMutableDictionary *newData = [data mutableCopy];
        // Add new key
        [newData setObject:imageName forKey:kNameImage];
        // Save image in file directory
        [PlistManager saveImage:[data valueForKey:kImage] name:imageName];
        // Clean old object
        data = nil;
        // Delete key of UIImage
        [newData removeObjectForKey:kImage];
        // Assign new data
        data = newData;
    }
    
    NSString *writableDBPath = [self getWritablePathForManageWithNameFile:fileName];
    
    NSMutableArray *misDatos = [[NSMutableArray alloc]initWithContentsOfFile:writableDBPath];
    
    
    if (misDatos.count==0) {
        [misDatos addObject:data];
        
    }else {
        for (int i = 0; i< [misDatos count]; i++) {
            if(![misDatos containsObject:data]){
                [misDatos addObject:data];
            }
            
        }
    }
    [misDatos writeToFile:writableDBPath atomically:YES];
 
    [PlistManager logWithFileName:fileName];
    
}



+ (void) deleteObjectWithData:(NSDictionary *)data fileName:(NSString *) fileName {
    
    NSString *writableDBPath = [self getWritablePathForManageWithNameFile:fileName];
    
    NSMutableArray *misDatos = [[NSMutableArray alloc]initWithContentsOfFile:writableDBPath];
    
    for (int i = 0; i< [misDatos count]; i++) {
        
        if([[misDatos objectAtIndex:i] isEqualToDictionary:data]){
            if (data[kNameImage]) {
                [PlistManager removeImage:[data valueForKey:kNameImage]];
            }
            [misDatos removeObjectAtIndex:i];
        }
    }
    
    [misDatos writeToFile:writableDBPath atomically:YES];
    
}

+ (void) deleteAllObjectsWithFileName:(NSString *) fileName{
    
    NSString *writableDBPath = [self getWritablePathForManageWithNameFile:fileName];
    
    NSMutableArray *misDatos = [[NSMutableArray alloc]initWithContentsOfFile:writableDBPath];
    
    // Loop with all objects
    for (int i = 0; i< [misDatos count]; i++) {
        // It has image
        if ([misDatos objectAtIndex:i][kNameImage]) {
            // Delete image
            [PlistManager removeImage:[[misDatos objectAtIndex:i]valueForKey:kNameImage]];
        }
    }
    
    [misDatos removeAllObjects];
    
    [misDatos writeToFile:writableDBPath atomically:YES];
    
}

+(NSDictionary *)getLastObjectWithFileName:(NSString *) fileName{
    
    NSString *writableDBPath = [self getWritablePathForManageWithNameFile:fileName];
    
    NSMutableArray *misDatos = [[NSMutableArray alloc]initWithContentsOfFile:writableDBPath];
    
    return [misDatos lastObject];
}

+(NSArray *)getAllObjectsWithFileName:(NSString *) fileName {
    
    NSString *writableDBPath = [self getWritablePathForManageWithNameFile:fileName];
    
    NSMutableArray *misDatos = [[NSMutableArray alloc]initWithContentsOfFile:writableDBPath];
    
    return misDatos;
}

+(BOOL)containsObject:(NSDictionary *)data fileName:(NSString *) fileName{
    
    NSString *writableDBPath = [self getWritablePathForManageWithNameFile:fileName];
    
    NSMutableArray *misDatos = [[NSMutableArray alloc]initWithContentsOfFile:writableDBPath];
    
    if([misDatos containsObject:data]){
        return YES;
    }
    
    return NO;
}

+(NSArray *) searchObjectsWith:(NSString *)stringSearch keyDictionary:(NSString *)keyDictionary fileName:(NSString *) fileName{
    
    NSArray *filteredArray = [[PlistManager getAllObjectsWithFileName:fileName] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", keyDictionary, stringSearch]];
    
    if(filteredArray.count > 0){
        return filteredArray;
    }
    
    return nil;
}

+ (void) logWithFileName:(NSString *)fileName{
    
    NSString *writableDBPath = [self getWritablePathForManageWithNameFile:fileName];
    
    NSMutableArray *misDatos = [[NSMutableArray alloc]initWithContentsOfFile:writableDBPath];
    
    NSLog(@"LOG: %@", misDatos);
}


+ (void)saveImage:(UIImage*)image name:(NSString *)imageName
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:imageName];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

+ (UIImage*)loadImageWithName:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+ (void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        //        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        //        [removeSuccessFulAlert show];
        NSLog(@"Delete image");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    
    // Comenzamos un contexto gráfico  (UIKit). El primer parámetro marca el tamaño que
    // tendrá dicho contexto. Segundo parámetro BOOL indica si el contenido es o no opaco.
    // El tercer parámetro nos permite definir la escala. Si en este último, indicamos 0,
    // se aplicará la escala correspondiente a la resolución de nuestro dispositivo (retina o no).
    // Si indicamos 1, se aplicará el tamaño exacto indicado en el primer parámetro.
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    // Dibujamos la imagen en el tamaño deseado dentro del contexto actual
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Recuperamos el contenido generado en el contexto y lo almacenamos
    // en una nueva UIImage
    UIImage *escaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Finalizamos el contexto gráfico
    UIGraphicsEndImageContext();
    
    // Devolvemos como parámetro la UIImage reescalada.
    return escaledImage;
    
}

+ (NSString *) getWritablePathForManageWithNameFile:(NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
    
}

+ (NSString *) createImageName{
    return [NSString stringWithFormat:@"%d.png",(int)[[NSDate date] timeIntervalSince1970]];
}

@end
