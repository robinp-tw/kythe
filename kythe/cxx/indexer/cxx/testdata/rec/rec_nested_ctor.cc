// Verifies that calls to constructors of nested classes are indexed.
namespace ns {

//- @S defines/binding StructS
struct S {
  //- @T defines/binding StructT
  struct T {
    //- @T defines/binding ConstructT
    T();

    //- @U defines/binding StructU
    struct U { };
  };

};

}  // namespace ns


void scope() {
  //- @S ref StructS
  //- @T ref StructT
  //- @T ref ConstructT
  //- @"ns::S::T()" ref/call ConstructT
  //- !{ @ns ref StructT }
  //- !{ @ns ref ConstructT }
  ns::S::T();

  //- @S ref StructS
  //- @T ref StructT
  //- @t ref ConstructT
  //- @t ref/call ConstructT
  ns::S::T t;

  //- @S ref StructS
  //- @T ref StructT
  //- @U ref StructU
  //- @U ref ConstructU
  //- @"ns::S::T::U()" ref/call ConstructU
  //- !{ @ns ref StructU }
  //- !{ @ns ref ConstructU }
  ns::S::T::U();

  //- @S ref StructS
  //- @T ref StructT
  //- @U ref StructU
  //- @u ref ConstructU
  //- @u ref/call ConstructU
  ns::S::T::U u;
}