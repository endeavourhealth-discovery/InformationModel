import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import {RecordModelLibraryComponent} from './record-model-library/record-model-library/record-model-library.component';
import {RecordModelModule} from './record-model-library/record-model.module';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import {HttpClientModule} from '@angular/common/http';

@NgModule({
  imports: [
    BrowserModule,
    BrowserAnimationsModule,

    HttpClientModule,
    RecordModelModule,
  ],
  providers: [],
  bootstrap: [RecordModelLibraryComponent]
})
export class AppModule { }
