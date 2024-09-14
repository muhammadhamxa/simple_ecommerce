import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ecommerce/src/products/presentation/bloc/product_events.dart';

import '../core/network_info.dart';
import '../src/cart/presentation/bloc/cart_bloc.dart';
import '../src/products/data/datasources/product_local_datasource.dart';
import '../src/products/data/datasources/product_remote_datasource.dart';
import '../src/products/data/repositories/product_repo_impl.dart';
import '../src/products/domain/repositories/product_repo.dart';
import '../src/products/domain/usecases/get_product_usecase.dart';
import '../src/products/domain/usecases/get_products_usecase.dart';
import '../src/products/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerSingleton<http.Client>(http.Client());
  sl.registerSingleton<InternetConnectionChecker>(InternetConnectionChecker());

  // Core
  sl.registerSingleton<NetworkInfo>(
      NetworkInfoImpl(sl<InternetConnectionChecker>()));

  // Data sources
  sl.registerSingleton<ProductRemoteDataSource>(
    ProductRemoteDataSourceImpl(
      client: sl<http.Client>(),
      baseUrl: 'https://fakestoreapi.com',
    ),
  );

  sl.registerSingleton<ProductLocalDataSource>(
    ProductLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerSingleton<ProductRepository>(
    ProductRepositoryImpl(
      remoteDataSource: sl<ProductRemoteDataSource>(),
      localDataSource: sl<ProductLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerSingleton<GetProducts>(GetProducts(sl<ProductRepository>()));
  sl.registerSingleton<GetProduct>(GetProduct(sl<ProductRepository>()));

  // Bloc
  sl
      .registerSingleton<ProductBloc>(
        ProductBloc(
          getProducts: sl<GetProducts>(),
          getProduct: sl<GetProduct>(),
        ),
      )
      .add(LoadProducts());

  sl.registerSingleton<CartBloc>(CartBloc());
}
