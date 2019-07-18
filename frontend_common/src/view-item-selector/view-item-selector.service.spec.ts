import { TestBed, inject } from '@angular/core/testing';

import { ViewItemSelectorService } from './view-item-selector.service';

describe('ViewItemSelectorService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ViewItemSelectorService]
    });
  });

  it('should be created', inject([ViewItemSelectorService], (service: ViewItemSelectorService) => {
    expect(service).toBeTruthy();
  }));
});
