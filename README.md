![](https://i.imgur.com/mX7lW5a.png)
#  MusicBoxApp
![](https://i.imgur.com/kR0odmq.png)
The API for music from [MusicBoxSwift](https://github.com/darkCavalier11/MusicBoxSwift).

The project uses a MVVM pattern. All the view controllers are inside `ViewControllers` directory and all view models inside `ViewModel` directory. There are few core data files to store musics locally and storing application metadata. `CoreDataModels` contain all the coredata files. This is a project for learning and fun. 

- **CoreData**: To store music and playlist related informations inside `CoreDataModels` directory.
- **Swinject**: Use as a DI tool and dependency management tool across the application to propagate and fetch view models at inside of different view controllers. This way view controller stays independent of any dependency and all the required dependency(primarily view models) are initilised during `viewDidLoad` help of `Container` provided by this package.
- **RxSwift**: This is at the center of each view model. App extensively used this to establish a MVVM pattern. Most view model variables are of type `Observable` bind to view controller's view or observed with custom logic. Any data from view model to view propagate via this observables. Any data from view controller to view model propagates via methods provided via view model. 

* All Illustrations used in the app are from [unDraw](https://undraw.co/).
* The awesome app logo is from [Ilham Fitrotul Hayat](https://www.flaticon.com/authors/ilham-fitrotul-hayat)
